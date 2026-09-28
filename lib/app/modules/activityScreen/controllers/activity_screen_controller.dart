import 'package:get/get.dart';
import 'package:project/app/services/storage_service.dart';

class ActivityScreenController extends GetxController {
  RxList activityList = [].obs;
  late final StorageService storageService;

  @override
  void onInit() {
    super.onInit();
    storageService = Get.find<StorageService>();
    loadActivities();
  }

  void loadActivities() {
    activityList.value = storageService.getActivities();
  }
}
