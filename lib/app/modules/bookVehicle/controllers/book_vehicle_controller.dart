import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project/app/services/snackbar.dart';

class BookVehicleController extends GetxController {
  //TODO: Implement BookVehicleController
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
  @override
  void onInit() {
    super.onInit();
    initVehicle();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initVehicle() async {
    await getVehicle();
    await getBrand();
    await getModel();
  }

  Future<void> getVehicle() async {
    try {
      loadingMap['getVehicle'] = true;
      final jsonFile = await rootBundle.loadString(
        "assets/json/dummyData.json",
      );
      final jsonData = jsonDecode(jsonFile);
      vehicleList.value = jsonData['vehicles'];
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
      final jsonFile = await rootBundle.loadString(
        "assets/json/dummyData.json",
      );
      final jsonData = jsonDecode(jsonFile);
      modelList.value = jsonData['model'];
    } catch (e) {
      showErrorSnackbar("Failed to fetch data");
      print("Error get vehicle: $e");
    } finally {
      loadingMap['getModel'] = false;
    }
  }

  Future<void> getBrand() async {
    try {
      loadingMap['getBrand'] = true;
      final jsonFile = await rootBundle.loadString(
        "assets/json/dummyData.json",
      );
      final jsonData = jsonDecode(jsonFile);
      brandList.value = jsonData['brand'];
    } catch (e) {
      showErrorSnackbar("Failed to fetch data");
      print("Error get vehicle: $e");
    } finally {
      loadingMap['getBrand'] = false;
    }
  }

  void saveVehicle() {
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
        "id": vehicleList.length + 1,
        "brand": selectedBrand.value,
        "number":
            "${platNumRegion.text.trim()} ${platNumRegist.text.trim()} ${platNumSubRegion.text.trim()}",
        "model": selectedModel.value,
        "year": int.tryParse(productionYear.value) ?? productionYear.value,
        "odometer": int.tryParse(odometer.value) ?? odometer.value,
        "isMain": false,
      };

      if (vehicleList.any((test) => test['id'] == data['id'])) return;
      vehicleList.add(data);
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
      selectedVehicle.remove(data);
    } else {
      selectedVehicle.add(data);
    }
  }

  bool isSelected(Map data) {
    return selectedVehicle.any((test) => test == data);
  }
}
