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
    pageIndex.value = 0;
    initVehicleSelection();
  }

  void initVehicleSelection() {
    final args = Get.arguments;
    dynamic clickedVehicle;

    if (args is Map) {
      if (args['vehicle'] != null) {
        clickedVehicle = args['vehicle'];
      } else if (args['vehicleId'] != null) {
        final List all = vehicleController.vehicleList.isNotEmpty
            ? vehicleController.vehicleList
            : vehicleController.storageService.getVehicles();
        for (final v in all) {
          if (v['id']?.toString() == args['vehicleId']?.toString()) {
            clickedVehicle = v;
            break;
          }
        }
      } else if (args.containsKey('brand') && args.containsKey('model')) {
        clickedVehicle = args;
      }
    }

    if (clickedVehicle != null && clickedVehicle is Map) {
      final selectedMap = Map<String, dynamic>.from(clickedVehicle);
      vehicleController.selectedVehicle.assignAll([selectedMap]);
      selectedVehicle.assignAll([selectedMap]);
      serviceController.syncWithSelectedVehicles([selectedMap]);
    } else {
      // Default to none
      vehicleController.selectedVehicle.clear();
      selectedVehicle.clear();
      serviceController.syncWithSelectedVehicles([]);
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
      scheduleController.updatePitAssignments();
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
      scheduleController.updatePitAssignments();
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
