import 'package:get/get.dart';
import 'package:project/app/modules/bookReview/controllers/book_review_controller.dart';
import 'package:project/app/modules/bookSchedule/controllers/book_schedule_controller.dart';
import 'package:project/app/modules/bookService/controllers/book_service_controller.dart';
import 'package:project/app/modules/bookVehicle/controllers/book_vehicle_controller.dart';
import 'package:project/app/services/snackbar.dart';

class BookScreenController extends GetxController {
  //TODO: Implement BookScreenController

  final vehicleController = Get.find<BookVehicleController>();
  final serviceController = Get.find<BookServiceController>();
  final scheduleController = Get.find<BookScheduleController>();
  final reviewController = Get.find<BookReviewController>();

  RxList selectedVehicle = [].obs;
  RxList selectedService = [].obs;
  RxList selectedSchedule = [].obs;

  RxInt pageIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void nextPage() async {
    if (vehicleController.selectedVehicle.isEmpty) {
      showInfoSnackbar("Mohon pilih motor terlebih dahulu!");
      return;
    }
    if (pageIndex.value == 3) return;
    pageIndex.value++;
    selectedVehicle = vehicleController.selectedVehicle;
    serviceController.selectedVehicle = vehicleController.selectedVehicle;
  }

  void prevPage() {
    if (pageIndex.value == 0) return;
    pageIndex.value--;
  }
}
