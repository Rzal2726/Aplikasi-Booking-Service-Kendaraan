import 'package:get/get.dart';

import '../controllers/service_screen_controller.dart';

class ServiceScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceScreenController>(
      () => ServiceScreenController(),
    );
  }
}
