import 'package:get/get.dart';
import 'package:project/app/modules/bookService/controllers/book_service_controller.dart';
import 'package:project/app/services/storage_service.dart';

class BookScheduleController extends GetxController {
  late final StorageService storageService;
  late final BookServiceController serviceController;

  // Workshop Details
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
  }

  void initSchedule() {
    _restoreDraftOrSetDefaults();
    _updatePitAssignments();
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
    final isParallel = workMethod.value == 'parallel';

    pitAssignments.clear();

    if (vehicles.isEmpty) return;

    // First vehicle
    final v1 = vehicles[0];
    pitAssignments.add({
      "pit": "Pit 03",
      "vehicleName": "${v1['brand']} ${v1['model']}",
      "plateNumber": v1['number'] ?? "B 1234 XYZ",
      "mechanic": "Bpk. Dadang",
      "time": "${selectedTimeSlot.value} WIB",
      "status": "Terjadwal",
    });

    // Second vehicle (if exists)
    if (vehicles.length > 1) {
      final v2 = vehicles[1];
      if (isParallel) {
        pitAssignments.add({
          "pit": "Pit 04",
          "vehicleName": "${v2['brand']} ${v2['model']}",
          "plateNumber": v2['number'] ?? "D 5678 ABC",
          "mechanic": "Bpk. Ilham",
          "time": "${selectedTimeSlot.value} WIB",
          "status": "Terjadwal",
        });
      } else {
        // Sequential: same pit, later time
        pitAssignments.add({
          "pit": "Pit 03",
          "vehicleName": "${v2['brand']} ${v2['model']}",
          "plateNumber": v2['number'] ?? "D 5678 ABC",
          "mechanic": "Bpk. Dadang",
          "time": "10:30 WIB",
          "status": "Terjadwal",
        });
      }
    }
  }

  String get estimatedEndTimeText {
    if (workMethod.value == 'parallel') {
      return "Estimasi selesai bersamaan: 10:30 WIB (~60 menit).";
    } else {
      return "Estimasi selesai berurutan: 11:30 WIB (~120 menit).";
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
      'workshop': workshopName.value,
      'workMethod': workMethod.value,
      'selectedDateIndex': selectedDateIndex.value,
      'selectedDate': availableDates[selectedDateIndex.value],
      'selectedTimeSlot': selectedTimeSlot.value,
      'estimatedEndTime': estimatedEndTimeText,
    };
    storageService.saveBookingDraft(draft);
  }
}
