import 'package:get/get.dart';
import 'package:project/app/services/storage_service.dart';

class ServiceScreenController extends GetxController {
  final count = 0.obs;
  RxList serviceList = [].obs;
  late final StorageService storageService;

  @override
  void onInit() {
    super.onInit();
    storageService = Get.find<StorageService>();
    loadServices();
  }

  void loadServices() {
    serviceList.value = storageService.getServices();
  }

  void increment() => count.value++;
}
