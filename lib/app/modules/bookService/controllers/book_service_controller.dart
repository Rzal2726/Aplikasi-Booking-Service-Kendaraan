import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/services/snackbar.dart';
import 'package:project/app/services/storage_service.dart';

class MotorSelectionState {
  dynamic vehicleId;
  RxnInt selectedServiceId = RxnInt();
  RxList<int> selectedSparePartIds = <int>[].obs;
  RxList<String> selectedSymptoms = <String>[].obs;
  TextEditingController notesController = TextEditingController();
  RxBool isExpanded = true.obs;

  MotorSelectionState({
    required this.vehicleId,
    int? serviceId,
    List<int>? sparePartIds,
    List<String>? symptoms,
    String notes = '',
    bool expanded = true,
  }) {
    selectedServiceId.value = serviceId;
    if (sparePartIds != null) selectedSparePartIds.assignAll(sparePartIds);
    if (symptoms != null) selectedSymptoms.assignAll(symptoms);
    notesController.text = notes;
    isExpanded.value = expanded;
  }

  Map<String, dynamic> toJson() => {
    'vehicleId': vehicleId,
    'selectedServiceId': selectedServiceId.value,
    'selectedSparePartIds': selectedSparePartIds.toList(),
    'selectedSymptoms': selectedSymptoms.toList(),
    'notes': notesController.text,
    'isExpanded': isExpanded.value,
  };
}

class BookServiceController extends GetxController {
  late final StorageService storageService;

  RxList selectedVehicle = [].obs;
  RxList serviceList = [].obs;
  RxList sparePartsList = [].obs;
  RxList<String> symptomsList = <String>[].obs;

  // Keyed by vehicleId.toString()
  final RxMap<String, MotorSelectionState> motorStates =
      <String, MotorSelectionState>{}.obs;

  @override
  void onInit() {
    super.onInit();
    storageService = Get.find<StorageService>();
    loadData();
  }

  Future<void> loadData() async {
    serviceList.value = storageService.getServices();
    sparePartsList.value = storageService.getSpareParts();
    symptomsList.value = storageService.getSymptoms();

    _initSelectionStates();
    if (selectedVehicle.isNotEmpty) {
      _restoreDraftOrSetDefaults();
    }
  }

  void syncWithSelectedVehicles(List vehicles) {
    selectedVehicle.assignAll(vehicles);
    _initSelectionStates();
    if (selectedVehicle.isNotEmpty) {
      _restoreDraftOrSetDefaults();
    }
  }

  void _initSelectionStates() {
    for (int i = 0; i < selectedVehicle.length; i++) {
      final v = selectedVehicle[i];
      final key = v['id'].toString();
      if (!motorStates.containsKey(key)) {
        motorStates[key] = MotorSelectionState(
          vehicleId: v['id'],
          expanded: i == 0, // Expand the first one by default
        );
        // Listen to notes changes
        motorStates[key]!.notesController.addListener(() {
          persistDraft();
        });
      }
    }
  }

  void _restoreDraftOrSetDefaults() {
    final draft = storageService.getBookingDraft();
    if (draft != null && draft['motorStates'] != null) {
      final Map states = draft['motorStates'];
      states.forEach((k, val) {
        if (motorStates.containsKey(k.toString())) {
          final s = motorStates[k.toString()]!;
          s.selectedServiceId.value = val['selectedServiceId'];
          if (val['selectedSparePartIds'] != null) {
            s.selectedSparePartIds.assignAll(
              List<int>.from(val['selectedSparePartIds']),
            );
          }
          if (val['selectedSymptoms'] != null) {
            s.selectedSymptoms.assignAll(
              List<String>.from(val['selectedSymptoms']),
            );
          }
          if (val['notes'] != null) {
            s.notesController.text = val['notes'];
          }
          if (val['isExpanded'] != null) {
            s.isExpanded.value = val['isExpanded'];
          }
        }
      });
    } else {
      // Default initial state matching the screenshot image:
      // Motor 1: Servis Berkala (id 1) + MPX2 (id 1) + Busi NGK (id 2) + 2 Symptoms + custom note
      if (selectedVehicle.isNotEmpty) {
        for (int i = 0; i < selectedVehicle.length; i++) {
          final key = selectedVehicle[i]['id'].toString();
          if (motorStates.containsKey(key)) {
            final s = motorStates[key]!;
            if (s.selectedServiceId.value == null && serviceList.isNotEmpty) {
              s.selectedServiceId.value = (serviceList.first['id'] as num).toInt();
            }
            if (i == 0) {
              if (s.selectedSparePartIds.isEmpty) {
                s.selectedSparePartIds.assignAll([1, 2]); // MPX2 and Busi NGK
              }
              if (s.selectedSymptoms.isEmpty) {
                s.selectedSymptoms.assignAll([
                  "Tarikan Gas Berat",
                  "Rem Bunyi Berdecit",
                ]);
              }
              if (s.notesController.text.isEmpty) {
                s.notesController.text = "Tolong cek getaran CVT saat rpm rendah.";
              }
              s.isExpanded.value = true;
            } else {
              s.isExpanded.value = false;
            }
          }
        }
      }
      persistDraft();
    }
  }

  MotorSelectionState getSelectionState(dynamic vehicleId) {
    final key = vehicleId.toString();
    if (!motorStates.containsKey(key)) {
      motorStates[key] = MotorSelectionState(vehicleId: vehicleId);
      motorStates[key]!.notesController.addListener(() {
        persistDraft();
      });
    }
    return motorStates[key]!;
  }

  void selectService(dynamic vehicleId, int serviceId) {
    final state = getSelectionState(vehicleId);
    if (state.selectedServiceId.value == serviceId) {
      // If tapped again, keep selected (radio button behavior)
      state.selectedServiceId.value = serviceId;
    } else {
      state.selectedServiceId.value = serviceId;
    }
    persistDraft();
  }

  void toggleSparePart(dynamic vehicleId, int partId) {
    final state = getSelectionState(vehicleId);
    if (state.selectedSparePartIds.contains(partId)) {
      state.selectedSparePartIds.remove(partId);
    } else {
      state.selectedSparePartIds.add(partId);
    }
    persistDraft();
  }

  void toggleSymptom(dynamic vehicleId, String symptom) {
    final state = getSelectionState(vehicleId);
    if (state.selectedSymptoms.contains(symptom)) {
      state.selectedSymptoms.remove(symptom);
    } else {
      state.selectedSymptoms.add(symptom);
    }
    persistDraft();
  }

  void toggleExpanded(dynamic vehicleId) {
    final state = getSelectionState(vehicleId);
    state.isExpanded.value = !state.isExpanded.value;
    persistDraft();
  }

  void addVehicleToBooking(Map vehicle) {
    if (!selectedVehicle.any((v) => v['id']?.toString() == vehicle['id']?.toString())) {
      selectedVehicle.add(vehicle);
      final key = vehicle['id'].toString();
      motorStates[key] = MotorSelectionState(
        vehicleId: vehicle['id'],
        expanded: true,
      );
      if (serviceList.isNotEmpty) {
        motorStates[key]!.selectedServiceId.value = (serviceList.first['id'] as num).toInt();
      }
      motorStates[key]!.notesController.addListener(() {
        persistDraft();
      });
      persistDraft();
      showSuccessSnackbar("${vehicle['brand']} ${vehicle['model']} ditambahkan ke booking");
    }
  }

  void removeVehicleFromBooking(dynamic vehicleId) {
    if (selectedVehicle.length <= 1) {
      showInfoSnackbar("Minimal 1 motor dalam booking servis");
      return;
    }
    selectedVehicle.removeWhere((v) => v['id']?.toString() == vehicleId.toString());
    motorStates.remove(vehicleId.toString());
    persistDraft();
  }

  // --- Calculations ---
  Map<String, dynamic>? getSelectedServiceData(dynamic vehicleId) {
    final state = getSelectionState(vehicleId);
    final serviceId = state.selectedServiceId.value;
    if (serviceId == null) return null;
    return serviceList.firstWhereOrNull((s) => s['id'] == serviceId);
  }

  List<Map<String, dynamic>> getSelectedSparePartsData(dynamic vehicleId) {
    final state = getSelectionState(vehicleId);
    return sparePartsList
        .where((p) => state.selectedSparePartIds.contains(p['id']))
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  double getVehicleSubtotal(dynamic vehicleId) {
    double total = 0.0;
    final service = getSelectedServiceData(vehicleId);
    if (service != null) {
      total += (service['price'] as num).toDouble();
    }
    final parts = getSelectedSparePartsData(vehicleId);
    for (final p in parts) {
      total += (p['price'] as num).toDouble();
    }
    return total;
  }

  int getVehicleEstimatedMinutes(dynamic vehicleId) {
    final service = getSelectedServiceData(vehicleId);
    if (service != null && service['durationMinutes'] != null) {
      return (service['durationMinutes'] as num).toInt();
    }
    return 60;
  }

  String getVehicleSummarySubtitle(dynamic vehicleId) {
    final service = getSelectedServiceData(vehicleId);
    final parts = getSelectedSparePartsData(vehicleId);

    if (service == null && parts.isEmpty) {
      return "Belum memilih layanan";
    }

    final serviceName = service != null
        ? service['name'].toString().split(' ').first
        : "";

    final partsNames = parts
        .map((p) => (p['shortName'] ?? p['name']).toString())
        .toList();

    if (serviceName.isNotEmpty && partsNames.isNotEmpty) {
      return "$serviceName + ${partsNames.join(' + ')}";
    } else if (serviceName.isNotEmpty) {
      return service?['name'] ?? "";
    } else {
      return partsNames.join(' + ');
    }
  }

  double get totalPrice {
    double sum = 0.0;
    for (final v in selectedVehicle) {
      sum += getVehicleSubtotal(v['id']);
    }
    return sum;
  }

  int get totalEstimatedMinutes {
    // Parallel pits: Total duration is the maximum duration among vehicles
    int maxMinutes = 0;
    for (final v in selectedVehicle) {
      final m = getVehicleEstimatedMinutes(v['id']);
      if (m > maxMinutes) maxMinutes = m;
    }
    return maxMinutes == 0 ? 60 : maxMinutes;
  }

  Future<void> persistDraft() async {
    final Map<String, dynamic> statesJson = {};
    motorStates.forEach((k, v) {
      statesJson[k] = v.toJson();
    });

    final draft = {
      'selectedVehicle': selectedVehicle.toList(),
      'motorStates': statesJson,
      'totalPrice': totalPrice,
      'totalEstimatedMinutes': totalEstimatedMinutes,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    await storageService.saveBookingDraft(draft);
  }
}
