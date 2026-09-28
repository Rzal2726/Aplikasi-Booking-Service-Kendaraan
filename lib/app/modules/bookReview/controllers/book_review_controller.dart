import 'package:get/get.dart';
import 'package:project/app/modules/bookSchedule/controllers/book_schedule_controller.dart';
import 'package:project/app/modules/bookService/controllers/book_service_controller.dart';
import 'package:project/app/routes/app_pages.dart';
import 'package:project/app/services/storage_service.dart';

class BookReviewController extends GetxController {
  late final StorageService storageService;
  late final BookServiceController serviceController;
  late final BookScheduleController scheduleController;

  final customerName = "John Doe".obs;
  final customerPhone = "0812-3456-7890".obs;
  final arrivalMethod = "Antar Langsung ke Bengkel".obs;
  final arrivalTime = "Tiba 09:15 WIB".obs;

  /// Discount is only applied when 2+ vehicles are booked (multi-motor bundle).
  double get discountAmount =>
      serviceController.selectedVehicle.length >= 2 ? 35000.0 : 0.0;

  @override
  void onInit() {
    super.onInit();
    storageService = Get.find<StorageService>();
    serviceController = Get.find<BookServiceController>();
    scheduleController = Get.find<BookScheduleController>();
  }

  double get subtotalCost {
    final vTotal = serviceController.totalPrice;
    return vTotal > 0 ? vTotal : 365000.0;
  }

  double get totalPayment {
    final total = subtotalCost - discountAmount;
    return total > 0 ? total : 0;
  }

  Future<void> confirmBooking() async {
    // Resolve workshopId from storage (use first workshop's id as default)
    final workshops = storageService.getWorkshops();
    final workshopId = workshops.isNotEmpty ? workshops.first['id'] : 1;

    // Resolve userId from storage (use first user's id as default)
    final users = storageService.getUsers();
    final userId = users.isNotEmpty ? users.first['id'] : 1;

    // Build nested activities array matching JSON schema:
    // { vehicleID, serviceIds (service + spare-parts combined), status }
    final List<Map<String, dynamic>> vehicleActivities = serviceController
        .selectedVehicle
        .map<Map<String, dynamic>>((v) {
          final vId = v['id'];
          final state = serviceController.getSelectionState(vId);

          final List<int> serviceIds = [];
          if (state.selectedServiceId.value != null) {
            serviceIds.add(state.selectedServiceId.value!);
          }
          serviceIds.addAll(state.selectedSparePartIds.toList());

          return {
            'vehicleID': vId,
            // Embed full vehicle snapshot so it can be displayed without a lookup
            'vehicle': Map<String, dynamic>.from(v as Map),
            'serviceIds': serviceIds,
            'symptoms': state.selectedSymptoms.toList(),
            'notes': state.notesController.text,
            'status': 1, // 1 = pending / Menunggu Kedatangan
          };
        })
        .toList();

    final now = DateTime.now();

    final activity = {
      // --- Core fields matching JSON schema ---
      'id': now.millisecondsSinceEpoch,
      'userId': userId,
      'workshopId': workshopId,
      'activities': vehicleActivities,
      'date': now.toIso8601String(),
      'status': 'pending',
      'totalPrice': totalPayment,

      // --- Supplementary display fields ---
      'code': 'MS-${now.millisecondsSinceEpoch.toString().substring(7)}',
      'workshop': scheduleController.workshopName.value,
      'workshopAddress': scheduleController.workshopAddress.value,
      'scheduleDate':
          "${scheduleController.availableDates[scheduleController.selectedDateIndex.value]['day']}, "
          "${scheduleController.availableDates[scheduleController.selectedDateIndex.value]['date']} "
          "${scheduleController.selectedMonthYear.value}",
      'time': "${scheduleController.selectedTimeSlot.value} WIB",
      'subtotal': subtotalCost,
      'discount': discountAmount,
      'paymentMethod': 'Bayar di Bengkel',
      'pitAssignments': scheduleController.pitAssignments.toList(),
      'createdAt': now.toIso8601String(),
    };

    await storageService.addActivity(activity);
    await storageService.clearBookingDraft();

    Get.toNamed(Routes.BOOK_CONFIRM, arguments: {"id": activity['id']});
  }
}
