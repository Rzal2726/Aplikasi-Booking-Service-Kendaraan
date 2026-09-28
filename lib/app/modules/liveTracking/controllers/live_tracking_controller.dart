import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:project/app/services/pdf_invoice_service.dart';
import 'package:project/app/services/storage_service.dart';

class LiveTrackingController extends GetxController {
  late final StorageService storageService;

  final Rx<Map<String, dynamic>?> activity = Rx(null);
  final statusSteps = <Map<String, dynamic>>[].obs;
  final selectedPitIndex = 0.obs;

  // Filter tabs: 0=Semua, 1=Sedang Dikerjakan, 2=Menunggu, 3=Selesai
  final selectedFilterTab = 0.obs;

  // Set of pit indices whose timeline details are expanded
  final expandedPits = <int>{}.obs;

  // PDF generation state
  final isGeneratingPdf = false.obs;

  @override
  void onInit() {
    super.onInit();
    storageService = Get.find<StorageService>();
    _loadData();
  }

  @override
  void onReady() {
    super.onReady();
    _loadData();
  }

  void _loadData() {
    // Load status steps from storage (from JSON dummyData)
    statusSteps.assignAll(storageService.getStatus());

    // Load activity from arguments
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['selectedPitIndex'] != null) {
        final idx = (args['selectedPitIndex'] as num).toInt();
        selectedPitIndex.value = idx;
        expandedPits.add(idx);
      }

      if (args['activity'] != null && args['activity'] is Map) {
        activity.value = Map<String, dynamic>.from(args['activity'] as Map);
        _initExpanded();
        return;
      }

      if (args['id'] != null) {
        final id = args['id'];
        final activities = storageService.getActivities();
        final found = activities.firstWhereOrNull((a) => a['id'] == id);
        if (found != null) {
          activity.value = found;
          _initExpanded();
          return;
        }
      }

      // If args itself is the activity map
      if (args['pitAssignments'] != null || args['code'] != null) {
        activity.value = Map<String, dynamic>.from(args);
        _initExpanded();
        return;
      }
    }

    // Fallback: first activity
    final all = storageService.getActivities();
    if (all.isNotEmpty) activity.value = all.first;
    _initExpanded();
  }

  void _initExpanded() {
    if (expandedPits.isEmpty) {
      final pits = pitAssignments;
      if (pits.isNotEmpty) {
        final idx = selectedPitIndex.value.clamp(0, pits.length - 1);
        expandedPits.add(idx);
      }
    }
  }

  // --- Filter Tabs ---
  void setFilterTab(int index) {
    selectedFilterTab.value = index;
  }

  void toggleTimelineExpanded(int pitIndex) {
    if (expandedPits.contains(pitIndex)) {
      expandedPits.remove(pitIndex);
    } else {
      expandedPits.add(pitIndex);
    }
  }

  bool isTimelineExpanded(int pitIndex) {
    return expandedPits.contains(pitIndex);
  }

  // Filtered pit assignments based on selectedFilterTab
  List<Map<String, dynamic>> get filteredPitAssignments {
    final pits = pitAssignments;
    switch (selectedFilterTab.value) {
      case 1: // Sedang Dikerjakan (status 2, 3, 4)
        return pits.where((p) {
          final s = (p['status'] as num?)?.toInt() ?? 0;
          return s >= 2 && s <= 4;
        }).toList();
      case 2: // Menunggu (status 1)
        return pits.where((p) {
          final s = (p['status'] as num?)?.toInt() ?? 0;
          return s <= 1;
        }).toList();
      case 3: // Selesai (status >= 5)
        return pits.where((p) {
          final s = (p['status'] as num?)?.toInt() ?? 0;
          return s >= 5;
        }).toList();
      default: // Semua
        return pits;
    }
  }

  int get allCount => pitAssignments.length;

  int get inProgressCount => pitAssignments.where((p) {
        final s = (p['status'] as num?)?.toInt() ?? 0;
        return s >= 2 && s <= 4;
      }).length;

  int get waitingCount => pitAssignments.where((p) {
        final s = (p['status'] as num?)?.toInt() ?? 0;
        return s <= 1;
      }).length;

  int get completedCount => pitAssignments.where((p) {
        final s = (p['status'] as num?)?.toInt() ?? 0;
        return s >= 5;
      }).length;

  // ---- Convenience getters ----
  String get bookingCode => activity.value?['code'] ?? '—';
  String get workshopName => activity.value?['workshop'] ?? '—';
  String get workshopAddress => activity.value?['workshopAddress'] ?? '';
  String get scheduleDate => activity.value?['scheduleDate'] ?? '—';
  String get time => activity.value?['time'] ?? '—';
  double get totalPrice =>
      (activity.value?['totalPrice'] as num?)?.toDouble() ?? 0;

  List<Map<String, dynamic>> get pitAssignments {
    final raw = activity.value?['pitAssignments'];
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(
      (raw as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  /// The currently viewed pit assignment (convenience)
  Map<String, dynamic>? get currentPit {
    final pits = pitAssignments;
    if (pits.isEmpty) return null;
    final idx = selectedPitIndex.value.clamp(0, pits.length - 1);
    return pits[idx];
  }

  /// Current vehicle status step index (0-based) from pit assignment
  int get currentStepIndex {
    final pit = currentPit;
    if (pit == null) return 0;
    final s = (pit['status'] as num?)?.toInt() ?? 0;
    return (s - 1).clamp(0, statusSteps.length - 1);
  }

  /// Returns a short detail description for a given step (based on JSON description + context)
  String stepDetail(int stepIndex) {
    if (statusSteps.isEmpty || stepIndex >= statusSteps.length) return '';
    final step = statusSteps[stepIndex];
    final desc = step['description'] as String? ?? '';

    // For the active step we can append the pit service info
    if (stepIndex == currentStepIndex) {
      final pit = currentPit;
      if (pit != null) {
        final mechanic = pit['mechanic'] ?? '';
        if (desc.isNotEmpty) return desc;
        if (mechanic.isNotEmpty) return 'Dikerjakan oleh $mechanic';
      }
    }
    return desc;
  }

  /// Returns detail description for a specific vehicle pit and step
  String getVehicleStepDetail(Map<String, dynamic> pit, int stepIndex) {
    if (statusSteps.isEmpty || stepIndex >= statusSteps.length) return '';
    final step = statusSteps[stepIndex];
    final desc = step['description'] as String? ?? '';

    final s = (pit['status'] as num?)?.toInt() ?? 0;
    final currentStep = (s - 1).clamp(0, statusSteps.length - 1);

    if (stepIndex == currentStep) {
      final mechanic = pit['mechanic'] ?? '';
      if (desc.isNotEmpty) return desc;
      if (mechanic.isNotEmpty) return 'Dikerjakan oleh $mechanic';
    }
    return desc;
  }

  String get estimatedEndTime {
    final pit = currentPit;
    if (pit == null) return '—';
    return pit['time'] ?? '—';
  }

  void selectPit(int index) {
    selectedPitIndex.value = index;
  }

  Map<String, dynamic>? getVehicle(dynamic vehicleId) {
    // Try embedded snapshot first
    final raw = activity.value?['activities'];
    if (raw != null) {
      for (final entry in (raw as List)) {
        final e = Map<String, dynamic>.from(entry as Map);
        if (e['vehicleID']?.toString() == vehicleId?.toString() && e['vehicle'] != null) {
          return Map<String, dynamic>.from(e['vehicle'] as Map);
        }
      }
    }
    // Fallback: storage lookup
    final vehicles = storageService.getVehicles();
    return vehicles.firstWhereOrNull(
      (v) => v['id']?.toString() == vehicleId?.toString(),
    );
  }

  List<Map<String, dynamic>> get vehicleActivities {
    final raw = activity.value?['activities'];
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(
      (raw as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  String buildPackageLabel(List<dynamic> serviceIds) {
    if (serviceIds.isEmpty) return '—';
    final services = storageService.getServices();
    final parts = storageService.getSpareParts();
    final labels = <String>[];
    for (final sid in serviceIds) {
      final svc = services.firstWhereOrNull((s) => s['id'] == sid);
      if (svc != null) {
        labels.add(svc['name'] as String);
      } else {
        final part = parts.firstWhereOrNull((p) => p['id'] == sid);
        if (part != null) labels.add((part['shortName'] ?? part['name']) as String);
      }
    }
    return labels.isNotEmpty ? labels.join(' + ') : '—';
  }

  Future<void> generateAndDownloadInvoice({bool preview = true}) async {
    if (activity.value == null) {
      Get.snackbar(
        'Perhatian',
        'Data pesanan tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isGeneratingPdf.value = true;
      final pdfBytes = await PdfInvoiceService.generateInvoicePdf(
        activity: activity.value!,
        storageService: storageService,
      );

      final filename = 'Invoice_$bookingCode.pdf';

      if (preview) {
        await Printing.layoutPdf(
          onLayout: (format) async => pdfBytes,
          name: filename,
        );
      } else {
        await Printing.sharePdf(
          bytes: pdfBytes,
          filename: filename,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Membuka Invoice',
        'Terjadi kendala saat menghasilkan PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGeneratingPdf.value = false;
    }
  }
}
