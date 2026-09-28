import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/services/snackbar.dart';
import 'package:project/app/services/storage_service.dart';

class GarageScreenController extends GetxController {
  final count = 0.obs;
  TextEditingController platNumRegion = TextEditingController();
  TextEditingController platNumRegist = TextEditingController();
  TextEditingController platNumSubRegion = TextEditingController();

  RxList vehicleList = [].obs;
  RxList modelList = [].obs;
  RxList brandList = [].obs;

  RxString productionYear = "".obs;
  RxString selectedBrand = "".obs;
  RxString selectedModel = "".obs;
  RxString odometer = "".obs;
  RxMap<String, bool> loadingMap = <String, bool>{}.obs;

  late final StorageService storageService;

  @override
  void onInit() {
    super.onInit();
    storageService = Get.find<StorageService>();
    initGarage();
    // Reset selected model whenever brand changes
    ever(selectedBrand, (_) => selectedModel.value = '');
  }

  Future<void> initGarage() async {
    await getVehicle();
    await getBrand();
    await getModel();
  }

  Future<void> getVehicle() async {
    try {
      loadingMap['getVehicle'] = true;
      vehicleList.value = storageService.getVehicles();
    } catch (e) {
      showErrorSnackbar("Failed to fetch data");
      print("Error get vehicle: $e");
    } finally {
      loadingMap['getVehicle'] = false;
    }
  }

  Map getVehicleById(int id) {
    return vehicleList.firstWhereOrNull((data) => data['id'] == id) ?? {};
  }

  Future<void> getModel() async {
    try {
      loadingMap['getModel'] = true;
      modelList.value = storageService.getModels();
    } catch (e) {
      showErrorSnackbar("Failed to fetch data");
      print("Error get model: $e");
    } finally {
      loadingMap['getModel'] = false;
    }
  }

  Future<void> getBrand() async {
    try {
      loadingMap['getBrand'] = true;
      brandList.value = storageService.getBrands();
    } catch (e) {
      showErrorSnackbar("Failed to fetch data");
      print("Error get brand: $e");
    } finally {
      loadingMap['getBrand'] = false;
    }
  }

  /// Returns only models whose brandId matches the currently selected brand.
  List<Map<String, dynamic>> get filteredModelList {
    if (selectedBrand.value.isEmpty) return [];
    final brandEntry = brandList.firstWhereOrNull(
      (b) => b['brand']?.toString() == selectedBrand.value,
    );
    if (brandEntry == null) return [];
    final brandId = brandEntry['id'];
    return modelList
        .where((m) => m['brandId']?.toString() == brandId?.toString())
        .map((m) => Map<String, dynamic>.from(m as Map))
        .toList();
  }

  Future<void> saveVehicle() async {
    try {
      if (selectedBrand.value.isEmpty) {
        showInfoSnackbar("Mohon isi Merk terlebih dahulu!");
        return;
      }
      if (selectedModel.value.isEmpty) {
        showInfoSnackbar("Mohon isi Model terlebih dahulu!");
        return;
      }
      if (platNumRegion.text.isEmpty ||
          platNumRegist.text.isEmpty ||
          platNumSubRegion.text.isEmpty) {
        showInfoSnackbar("Mohon isi Nomor Plat Polisi terlebih dahulu!");
        return;
      }
      if (productionYear.value.isEmpty) {
        showInfoSnackbar("Mohon isi Tahun Pembuatan terlebih dahulu!");
        return;
      }
      if (odometer.value.isEmpty) {
        showInfoSnackbar("Mohon isi Odometer terlebih dahulu!");
        return;
      }
      if (Get.isBottomSheetOpen == true) {
        Get.closeAllSnackbars();
        Get.back();
      }
      final data = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "brand": selectedBrand.value,
        "number":
            "${platNumRegion.text.trim()} ${platNumRegist.text.trim()} ${platNumSubRegion.text.trim()}",
        "model": selectedModel.value,
        "year": int.tryParse(productionYear.value) ?? productionYear.value,
        "odometer": int.tryParse(odometer.value) ?? odometer.value,
        "isMain": false,
      };

      if (vehicleList.any((test) => test['number'] == data['number'])) {
        showInfoSnackbar("Motor dengan nomor plat ini sudah ada!");
        return;
      }

      await storageService.addVehicle(data);
      vehicleList.value = storageService.getVehicles();
      showSuccessSnackbar("Berhasil menambahkan motor ke garasi!");
    } catch (e) {
      showErrorSnackbar(
        "Gagal menambahkan motor ke garasi\nMohon coba lagi nanti!",
      );
    } finally {
      selectedBrand.value = "";
      selectedModel.value = "";
      platNumRegion.clear();
      platNumRegist.clear();
      platNumSubRegion.clear();
      productionYear.value = "";
      odometer.value = "";
    }
  }

  Future<void> setMainVehicle(dynamic id) async {
    try {
      final list = storageService.getVehicles();
      for (final v in list) {
        v['isMain'] = (v['id'] == id);
      }
      await storageService.saveVehicles(list);
      await getVehicle();
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
      showSuccessSnackbar("Berhasil mengubah motor utama!");
    } catch (e) {
      showErrorSnackbar("Gagal mengubah status motor utama.");
    }
  }

  Future<void> deleteVehicle(dynamic id) async {
    try {
      await storageService.deleteVehicle(id);
      await getVehicle();
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
      showSuccessSnackbar("Motor berhasil dihapus dari garasi!");
    } catch (e) {
      showErrorSnackbar("Gagal menghapus motor dari garasi.");
    }
  }

  List<Map<String, dynamic>> getVehicleActivities(
    dynamic vehicleId,
    String plateNumber,
  ) {
    final all = storageService.getActivities();
    final cleanPlate = plateNumber.replaceAll(' ', '').toUpperCase();
    return all.where((act) {
      final pits = act['pitAssignments'] as List? ?? [];
      final hasPit = pits.any((p) {
        final pId = p['vehicleId'];
        final pPlate = (p['plateNumber'] ?? '')
            .toString()
            .replaceAll(' ', '')
            .toUpperCase();
        return pId == vehicleId || (cleanPlate.isNotEmpty && pPlate == cleanPlate);
      });
      if (hasPit) return true;

      final subActs = act['activities'] as List? ?? [];
      final hasSub = subActs.any((sa) => sa['vehicleID'] == vehicleId);
      return hasSub;
    }).toList();
  }

  List<Map<String, dynamic>> getSpareParts() => storageService.getSpareParts();
  List<String> getSymptoms() => storageService.getSymptoms();
  List<Map<String, dynamic>> getServices() => storageService.getServices();
}
