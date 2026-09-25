import 'package:get/get.dart';

import '../controllers/book_vehicle_controller.dart';

class BookVehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookVehicleController>(
      () => BookVehicleController(),
    );
  }
}
