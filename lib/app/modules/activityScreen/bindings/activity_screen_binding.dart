import 'package:get/get.dart';

import '../controllers/activity_screen_controller.dart';

class ActivityScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityScreenController>(
      () => ActivityScreenController(),
    );
  }
}
