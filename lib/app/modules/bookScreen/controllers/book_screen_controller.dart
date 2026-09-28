import 'package:get/get.dart';
import 'package:project/app/modules/bookReview/controllers/book_review_controller.dart';
import 'package:project/app/modules/bookSchedule/controllers/book_schedule_controller.dart';
import 'package:project/app/modules/bookService/controllers/book_service_controller.dart';
import 'package:project/app/modules/bookVehicle/controllers/book_vehicle_controller.dart';
import 'package:project/app/services/snackbar.dart';

class BookScreenController extends GetxController {
  final vehicleController = Get.find<BookVehicleController>();
  final serviceController = Get.find<BookServiceController>();
  final scheduleController = Get.find<BookScheduleController>();
  final reviewController = Get.find<BookReviewController>();

  RxList selectedVehicle = [].obs;
  RxList selectedService = [].obs;
  RxList selectedSchedule = [].obs;

  RxInt pageIndex = 0.obs; // Defaults to Step 0 (BookVehicle)

  @override
  void onInit() {
    super.onInit();
    // Synchronize vehicle selection
    if (vehicleController.selectedVehicle.isNotEmpty) {
      selectedVehicle.assignAll(vehicleController.selectedVehicle);
      serviceController.syncWithSelectedVehicles(vehicleController.selectedVehicle);
    } else if (serviceController.selectedVehicle.isNotEmpty) {
      selectedVehicle.assignAll(serviceController.selectedVehicle);
      vehicleController.selectedVehicle.assignAll(serviceController.selectedVehicle);
    }
  }

  void nextPage() {
    if (pageIndex.value == 0) {
      if (vehicleController.selectedVehicle.isEmpty) {
        showInfoSnackbar("Mohon pilih motor terlebih dahulu!");
        return;
      }
      selectedVehicle.assignAll(vehicleController.selectedVehicle);
      serviceController.syncWithSelectedVehicles(vehicleController.selectedVehicle);
    } else if (pageIndex.value == 1) {
      // Validate that at least one service is selected for each motor
      for (final v in serviceController.selectedVehicle) {
        final state = serviceController.getSelectionState(v['id']);
        if (state.selectedServiceId.value == null) {
          showInfoSnackbar(
            "Mohon pilih paket servis untuk ${v['brand']} ${v['model']}",
          );
          return;
        }
      }
    }
    if (pageIndex.value < 3) {
      pageIndex.value++;
    }
  }

  void prevPage() {
    if (pageIndex.value > 0) {
      pageIndex.value--;
    }
  }
}
