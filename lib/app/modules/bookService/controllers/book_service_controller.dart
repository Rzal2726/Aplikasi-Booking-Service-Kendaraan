import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project/app/services/snackbar.dart';

class BookServiceController extends GetxController {
  //TODO: Implement BookServiceController

  final count = 0.obs;
  RxList selectedVehicle = [].obs;
  RxList serviceList = [].obs;
  RxMap selectedService = {}.obs;
  @override
  void onInit() {
    super.onInit();
    getServices();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getServices() async {
    try {
      final jsonFile = await rootBundle.loadString(
        "assets/json/dummyData.json",
      );
      final jsonData = jsonDecode(jsonFile);
      serviceList.value = jsonData['services'];
    } catch (e) {
      showErrorSnackbar("Failed to fetch data");
      print("Error get vehicle: $e");
    } finally {}
  }
}
