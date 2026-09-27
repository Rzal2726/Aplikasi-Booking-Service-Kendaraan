import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project/app/services/snackbar.dart';

class GarageScreenController extends GetxController {
  //TODO: Implement GarageScreenController

  final count = 0.obs;
  RxList vehicleList = [].obs;
  RxList modelList = [].obs;
  RxList brandList = [].obs;
  RxMap<String, bool> loadingMap = <String, bool>{}.obs;
  @override
  void onInit() {
    super.onInit();
    initGarage();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initGarage() async {
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
}
