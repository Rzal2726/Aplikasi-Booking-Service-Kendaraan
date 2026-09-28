import 'package:get/get.dart';
import 'package:project/app/services/storage_service.dart';

class ServiceScreenController extends GetxController {
  final count = 0.obs;
  RxList serviceList = [].obs;
  RxList activityList = [].obs;
  final selectedTab = 0.obs; // 0=Semua Aktif, 1=Sedang Dikerjakan, 2=Menunggu
  final searchQuery = ''.obs;

  late final StorageService storageService;

  @override
  void onInit() {
    super.onInit();
    storageService = Get.find<StorageService>();
    loadServices();
    loadActivities();
  }

  void loadServices() {
    serviceList.value = storageService.getServices();
  }

  void loadActivities() {
    activityList.value = storageService.getActivities();
  }

  Map getServiceById(int id) {
    return serviceList.firstWhereOrNull((test) => test['id'] == id) ?? {};
  }

  List get filteredActivities {
    final query = searchQuery.value.toLowerCase();
    final all = activityList.where((a) {
      if (query.isEmpty) return true;
      final workshopStr = (a['workshop'] ?? '').toString().toLowerCase();
      final codeStr = (a['code'] ?? '').toString().toLowerCase();
      return workshopStr.contains(query) || codeStr.contains(query);
    }).toList();

    switch (selectedTab.value) {
      case 1: // Sedang Dikerjakan
        return all.where((a) => a['status'] == 'pending').toList();
      case 2: // Terjadwal / Menunggu
        return all.where((a) => a['status'] == 'scheduled').toList();
      default: // Semua Aktif (not completed)
        return all.where((a) => a['status'] != 'COMPLETED').toList();
    }
  }

  int get activeCount =>
      activityList.where((a) => a['status'] != 'COMPLETED').length;

  int get ongoingCount =>
      activityList.where((a) => a['status'] == 'pending').length;

  int get scheduledCount =>
      activityList.where((a) => a['status'] == 'scheduled').length;
}
