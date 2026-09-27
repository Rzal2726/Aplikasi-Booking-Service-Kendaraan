import 'package:get/get.dart';
import 'package:project/app/modules/accountScreen/controllers/account_screen_controller.dart';
import 'package:project/app/modules/activityScreen/controllers/activity_screen_controller.dart';
import 'package:project/app/modules/garageScreen/controllers/garage_screen_controller.dart';
import 'package:project/app/modules/serviceScreen/controllers/service_screen_controller.dart';

import '../controllers/home_screen_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
    Get.lazyPut<GarageScreenController>(() => GarageScreenController());
    Get.lazyPut<ServiceScreenController>(() => ServiceScreenController());
    Get.lazyPut<ActivityScreenController>(() => ActivityScreenController());
    Get.lazyPut<AccountScreenController>(() => AccountScreenController());
  }
}
