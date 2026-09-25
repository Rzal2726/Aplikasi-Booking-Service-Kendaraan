import 'package:get/get.dart';

import '../controllers/garage_screen_controller.dart';

class GarageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GarageScreenController>(
      () => GarageScreenController(),
    );
  }
}
