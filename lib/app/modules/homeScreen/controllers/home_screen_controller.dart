import 'package:get/get.dart';
import 'package:project/app/modules/accountScreen/controllers/account_screen_controller.dart';
import 'package:project/app/modules/activityScreen/controllers/activity_screen_controller.dart';
import 'package:project/app/modules/garageScreen/controllers/garage_screen_controller.dart';
import 'package:project/app/modules/serviceScreen/controllers/service_screen_controller.dart';

class HomeScreenController extends GetxController {
  //TODO: Implement HomeScreenController

  RxInt pageIndex = 0.obs;
  RxString appBarTitle = "Home".obs;

  final garageController = Get.find<GarageScreenController>();
  final serviceController = Get.find<ServiceScreenController>();
  final activityController = Get.find<ActivityScreenController>();
  final accountController = Get.find<AccountScreenController>();
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
}
