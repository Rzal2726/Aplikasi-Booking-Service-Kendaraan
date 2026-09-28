import 'package:get/get.dart';
import 'package:project/app/modules/bookService/controllers/book_service_controller.dart';
import 'package:project/app/services/storage_service.dart';

class BookScheduleController extends GetxController {
  late final StorageService storageService;
  late final BookServiceController serviceController;

  // Workshop Details (loaded from storage)
  final workshopsList = <Map<String, dynamic>>[].obs;
  final selectedWorkshopId = 1.obs;
  final workshopName = "MotoServ Sukajadi - Bandung".obs;
  final workshopAddress = "Jl. Sukajadi No. 142, Bandung".obs;
  final workshopRating = "4.9 / 5.0".obs;
  final workshopReviews = "1.2k+ ulasan".obs;
  final workshopDistance = "2.4 km".obs;
  final workshopTravelTime = "~8 mnt jalan".obs;
  final workshopActivePits = "6 Pit Aktif".obs;
  final workshopPitEquip = "Alat hidrolik".obs;

  // Work Method: 'parallel' or 'sequential'
  final workMethod = 'parallel'.obs;

  // Selected Date
  final selectedMonthYear = "Oktober 2026".obs;
  final selectedDateIndex = 2.obs; // Defaults to Sab 24
  final availableDates = <Map<String, dynamic>>[
    {"day": "Kam", "date": "22", "status": "Ada", "available": true},
    {"day": "Jum", "date": "23", "status": "Ada", "available": true},
    {"day": "Sab", "date": "24", "status": "Pilihan", "available": true},
    {"day": "Min", "date": "25", "status": "Ada", "available": true},
    {"day": "Sen", "date": "26", "status": "Ada", "available": true},
  ].obs;

  // Selected Time Slot
  final selectedTimeSlot = "09:30".obs;

  // Pit and Mechanic Assignment
  final pitAssignments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    storageService = Get.find<StorageService>();
    serviceController = Get.find<BookServiceController>();
    initSchedule();
    ever(serviceController.selectedVehicle, (_) {
      _updatePitAssignments();
    });
  }

  void initSchedule() {
    _loadWorkshopFromStorage();
    _restoreDraftOrSetDefaults();
    _updatePitAssignments();
  }

  void _loadWorkshopFromStorage() {
    final workshops = storageService.getWorkshops();
    workshopsList.assignAll(workshops);
    if (workshops.isNotEmpty) {
      final draft = storageService.getBookingDraft();
      final sched = draft != null ? draft['schedule'] as Map<String, dynamic>? : null;
      final savedId = sched?['workshopId'];

      Map<String, dynamic> w = workshops.first;
      if (savedId != null) {
        final match = workshops.cast<Map<String, dynamic>?>().firstWhere(
          (element) => element?['id'] == savedId,
          orElse: () => null,
        );
        if (match != null) {
          w = match;
        }
      }
      selectWorkshop(w, shouldPersist: false);
    }
  }

  void selectWorkshop(Map<String, dynamic> w, {bool shouldPersist = true}) {
    selectedWorkshopId.value = w['id'] ?? selectedWorkshopId.value;
    workshopName.value = w['name'] ?? workshopName.value;
    workshopAddress.value = w['address'] ?? workshopAddress.value;

    final pit = w['pit'];
    if (pit != null) {
      workshopActivePits.value = "$pit Pit Aktif";
    }

    final rating = w['rating'];
    if (rating != null) {
      final rStr = rating.toString().replaceAll(',', '.');
      workshopRating.value = rStr.contains('/') ? rStr : "$rStr / 5.0";
    }

    if (w['reviews'] != null) {
      workshopReviews.value = "${w['reviews']} ulasan";
    } else {
      workshopReviews.value = (w['id'] == 2) ? "890+ ulasan" : "1.2k+ ulasan";
    }

    if (w['distance'] != null) {
      workshopDistance.value = "${w['distance']}";
    } else {
      workshopDistance.value = (w['id'] == 2) ? "12.4 km" : "2.4 km";
    }

    if (w['travelTime'] != null) {
      workshopTravelTime.value = "${w['travelTime']}";
    } else {
      workshopTravelTime.value = (w['id'] == 2) ? "~35 mnt jalan" : "~8 mnt jalan";
    }

    if (w['pitEquip'] != null) {
      workshopPitEquip.value = "${w['pitEquip']}";
    }

    _updatePitAssignments();

    if (shouldPersist) {
      persistSchedule();
    }
  }

  void setWorkMethod(String method) {
    workMethod.value = method;
    _updatePitAssignments();
    persistSchedule();
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
    persistSchedule();
  }

  void selectTimeSlot(String time) {
    selectedTimeSlot.value = time;
    _updatePitAssignments();
    persistSchedule();
  }

  void _updatePitAssignments() {
    final vehicles = serviceController.selectedVehicle;
    pitAssignments.clear();

    if (vehicles.isEmpty) return;

    if (vehicles.length < 2) {
      workMethod.value = 'single';
      final v = vehicles[0];
      pitAssignments.add({
        "pit": "Pit 03",
        "vehicleName": "${v['brand']} ${v['model']}",
        "plateNumber": v['number'] ?? "B 1234 XYZ",
        "mechanic": "Bpk. Dadang",
        "time": "${selectedTimeSlot.value} WIB",
        "status": 3,
      });
      return;
    }

    if (workMethod.value == 'single') {
      workMethod.value = 'parallel';
    }

    final isParallel = workMethod.value == 'parallel';
    final mechanics = [
      "Bpk. Dadang",
      "Bpk. Ilham",
      "Bpk. Wahyu",
      "Bpk. Joko",
      "Bpk. Arif",
    ];

    for (int i = 0; i < vehicles.length; i++) {
      final v = vehicles[i];
      if (isParallel) {
        final pitNumber = (3 + i).toString().padLeft(2, '0');
        final mechanic = mechanics[i % mechanics.length];
        pitAssignments.add({
          "pit": "Pit $pitNumber",
          "vehicleName": "${v['brand']} ${v['model']}",
          "plateNumber": v['number'] ?? "",
          "mechanic": mechanic,
          "time": "${selectedTimeSlot.value} WIB",
          "status": i == 0 ? 3 : 1,
        });
      } else {
        // Sequential: same pit, staggered by 60 mins each
        final timeParts = selectedTimeSlot.value.split(':');
        final startHour = int.tryParse(timeParts.isNotEmpty ? timeParts[0] : '09') ?? 9;
        final startMin = int.tryParse(timeParts.length > 1 ? timeParts[1] : '30') ?? 30;
        final totalMinutesOffset = i * 60;
        final slotMin = (startMin + totalMinutesOffset) % 60;
        final slotHour = startHour + ((startMin + totalMinutesOffset) ~/ 60);
        final timeStr =
            "${slotHour.toString().padLeft(2, '0')}:${slotMin.toString().padLeft(2, '0')} WIB";

        pitAssignments.add({
          "pit": "Pit 03",
          "vehicleName": "${v['brand']} ${v['model']}",
          "plateNumber": v['number'] ?? "",
          "mechanic": "Bpk. Dadang",
          "time": timeStr,
          "status": i == 0 ? 3 : 1,
        });
      }
    }
  }

  void updatePitAssignments() {
    _updatePitAssignments();
  }

  String get estimatedEndTimeText {
    final count = serviceController.selectedVehicle.length;
    if (count < 2) {
      final totalMins = serviceController.totalEstimatedMinutes > 0
          ? serviceController.totalEstimatedMinutes
          : 60;
      return "Estimasi selesai: 10:30 WIB (~$totalMins menit).";
    }
    if (workMethod.value == 'parallel') {
      return "Estimasi selesai bersamaan: 10:30 WIB (~60 menit).";
    } else {
      final totalMins = count * 60;
      return "Estimasi selesai berurutan: 11:30 WIB (~$totalMins menit).";
    }
  }

  void _restoreDraftOrSetDefaults() {
    final draft = storageService.getBookingDraft();
    if (draft != null && draft['schedule'] != null) {
      final Map sched = draft['schedule'];
      if (sched['workMethod'] != null) {
        workMethod.value = sched['workMethod'];
      }
      if (sched['selectedDateIndex'] != null) {
        selectedDateIndex.value = sched['selectedDateIndex'];
      }
      if (sched['selectedTimeSlot'] != null) {
        selectedTimeSlot.value = sched['selectedTimeSlot'];
      }
    }
  }

  void persistSchedule() {
    final draft = storageService.getBookingDraft() ?? {};
    draft['schedule'] = {
      'workshopId': selectedWorkshopId.value,
      'workshop': workshopName.value,
      'workshopAddress': workshopAddress.value,
      'workMethod': workMethod.value,
      'selectedDateIndex': selectedDateIndex.value,
      'selectedDate': availableDates[selectedDateIndex.value],
      'selectedTimeSlot': selectedTimeSlot.value,
      'estimatedEndTime': estimatedEndTimeText,
    };
    storageService.saveBookingDraft(draft);
  }
}
