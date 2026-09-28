import 'package:get/get.dart';
import 'package:project/app/modules/bookReview/controllers/book_review_controller.dart';
import 'package:project/app/modules/bookSchedule/controllers/book_schedule_controller.dart';
import 'package:project/app/modules/bookService/controllers/book_service_controller.dart';
import 'package:project/app/modules/bookVehicle/controllers/book_vehicle_controller.dart';

import '../controllers/book_screen_controller.dart';

class BookScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookScreenController>(() => BookScreenController());
    Get.lazyPut<BookReviewController>(() => BookReviewController());
    Get.lazyPut<BookVehicleController>(() => BookVehicleController());
    Get.lazyPut<BookScheduleController>(() => BookScheduleController());
    Get.lazyPut<BookServiceController>(() => BookServiceController());
  }
}
