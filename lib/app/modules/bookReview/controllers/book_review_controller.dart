import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/modules/bookSchedule/controllers/book_schedule_controller.dart';
import 'package:project/app/modules/bookService/controllers/book_service_controller.dart';
import 'package:project/app/routes/app_pages.dart';
import 'package:project/app/services/storage_service.dart';

class BookReviewController extends GetxController {
  late final StorageService storageService;
  late final BookServiceController serviceController;
  late final BookScheduleController scheduleController;

  final customerName = "Budi Santoso".obs;
  final customerPhone = "0812-3456-7890".obs;
  final arrivalMethod = "Antar Langsung ke Bengkel".obs;
  final arrivalTime = "Tiba 09:15 WIB".obs;

  final discountAmount = 35000.0.obs;

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
    final total = subtotalCost - discountAmount.value;
    return total > 0 ? total : 0;
  }

  Future<void> confirmBooking() async {
    final activity = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'code':
          'MS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'workshop': scheduleController.workshopName.value,
      'date':
          "${scheduleController.availableDates[scheduleController.selectedDateIndex.value]['day']}, ${scheduleController.availableDates[scheduleController.selectedDateIndex.value]['date']} ${scheduleController.selectedMonthYear.value}",
      'time': "${scheduleController.selectedTimeSlot.value} WIB",
      'vehicles': serviceController.selectedVehicle.toList(),
      'subtotal': subtotalCost,
      'discount': discountAmount.value,
      'totalPrice': totalPayment,
      'status': 'Menunggu Kedatangan',
      'paymentMethod': 'Bayar di Bengkel',
      'createdAt': DateTime.now().toIso8601String(),
    };

    await storageService.addActivity(activity);
    await storageService.clearBookingDraft();

    Get.toNamed(Routes.BOOK_CONFIRM, arguments: {"id": activity['id']});
  }
}
