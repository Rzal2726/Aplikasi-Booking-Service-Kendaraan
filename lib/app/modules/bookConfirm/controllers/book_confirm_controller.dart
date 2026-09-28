import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project/app/routes/app_pages.dart';
import 'package:project/app/services/snackbar.dart';
import 'package:project/app/services/storage_service.dart';

class BookConfirmController extends GetxController {
  late final StorageService storageService;

  final Rx<Map<String, dynamic>?> activity = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    storageService = Get.find<StorageService>();
    _loadActivity();
  }

  void _loadActivity() {
    final args = Get.arguments;
    if (args == null) return;

    final id = args['id'];
    final activities = storageService.getActivities();
    final found = activities.firstWhereOrNull((a) => a['id'] == id);
    if (found != null) {
      activity.value = found;
    }
  }

  // --- Convenience getters ---
  String get bookingCode => activity.value?['code'] ?? '—';
  String get workshopName => activity.value?['workshop'] ?? '—';
  String get scheduleDate => activity.value?['scheduleDate'] ?? '—';
  String get time => activity.value?['time'] ?? '—';
  double get totalPrice =>
      (activity.value?['totalPrice'] as num?)?.toDouble() ?? 0;
  double get discount => (activity.value?['discount'] as num?)?.toDouble() ?? 0;
  String get paymentMethod =>
      activity.value?['paymentMethod'] ?? 'Bayar di Bengkel';

  List<Map<String, dynamic>> get vehicleActivities {
    final raw = activity.value?['activities'];
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(
      (raw as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  // Resolve vehicle detail - first try embedded snapshot, then fallback to storage
  Map<String, dynamic>? getVehicle(dynamic vehicleId) {
    // Try to get the embedded vehicle snapshot from the activity entry
    final raw = activity.value?['activities'];
    if (raw != null) {
      for (final entry in (raw as List)) {
        final e = Map<String, dynamic>.from(entry as Map);
        if (e['vehicleID']?.toString() == vehicleId?.toString() && e['vehicle'] != null) {
          return Map<String, dynamic>.from(e['vehicle'] as Map);
        }
      }
    }
    // Fallback: lookup from storage
    final vehicles = storageService.getVehicles();
    return vehicles.firstWhereOrNull(
      (v) => v['id']?.toString() == vehicleId?.toString(),
    );
  }

  // Resolve service name by serviceId from storage
  String getServiceName(int serviceId) {
    final services = storageService.getServices();
    final s = services.firstWhereOrNull((s) => s['id'] == serviceId);
    return s?['name'] ?? '—';
  }

  // Resolve spare part name by partId from storage
  String getPartName(int partId) {
    final parts = storageService.getSpareParts();
    final p = parts.firstWhereOrNull((p) => p['id'] == partId);
    return p?['shortName'] ?? p?['name'] ?? '—';
  }

  // Build a human-readable package label for a vehicle's serviceIds
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
        if (part != null) {
          labels.add((part['shortName'] ?? part['name']) as String);
        }
      }
    }
    return labels.join(' + ');
  }

  // Pit assignment for a vehicle by index (from scheduleController pit assignments
  // stored in supplementary fields, or fallback)
  String getPitLabel(int index) {
    final assignments = _getPitAssignments();
    if (index < assignments.length) return assignments[index]['pit'] ?? '—';
    return 'Pit 0${index + 3}';
  }

  String getMechanic(int index) {
    final assignments = _getPitAssignments();
    if (index < assignments.length)
      return assignments[index]['mechanic'] ?? '—';
    return '—';
  }

  List<Map<String, dynamic>> _getPitAssignments() {
    final raw = activity.value?['pitAssignments'];
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(
      (raw as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  void copyBookingCode() {
    Clipboard.setData(ClipboardData(text: bookingCode));
    showSuccessSnackbar('Kode booking disalin!');
  }

  void goHome() {
    Get.offAllNamed(Routes.HOME_SCREEN);
  }

  void goTracking() {
    final act = activity.value;
    Get.toNamed(
      Routes.LIVE_TRACKING,
      arguments: {
        'id': act?['id'],
        'activity': act,
      },
    );
  }
}
