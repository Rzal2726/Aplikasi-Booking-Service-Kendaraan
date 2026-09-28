import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/services/snackbar.dart';
import 'package:project/app/services/storage_service.dart';

class BookVehicleController extends GetxController {
  TextEditingController platNumRegion = TextEditingController();
  TextEditingController platNumRegist = TextEditingController();
  TextEditingController platNumSubRegion = TextEditingController();

  RxList vehicleList = [].obs;
  RxList modelList = [].obs;
  RxList brandList = [].obs;
  RxList selectedVehicle = [].obs;

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
    initVehicle();
  }

  Future<void> initVehicle() async {
    await getVehicle();
    await getBrand();
    await getModel();

    // Default: If no vehicle selected yet, select the primary vehicle (or first one)
    if (selectedVehicle.isEmpty && vehicleList.isNotEmpty) {
      final mainVehicle = vehicleList.firstWhere(
        (v) => v['isMain'] == true,
        orElse: () => vehicleList.first,
      );
      selectedVehicle.add(mainVehicle);
    }
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
      selectedVehicle.add(data); // Auto select newly added vehicle
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

  void selectVehicle(Map data) {
    if (isSelected(data)) {
      selectedVehicle.removeWhere((item) => item['id'] == data['id']);
    } else {
      selectedVehicle.add(data);
    }
  }

  bool isSelected(Map data) {
    return selectedVehicle.any((test) => test['id'] == data['id']);
  }
}
