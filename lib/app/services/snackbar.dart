import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/const/appcolors.dart';

void showSuccessSnackbar(String message) {
  Get.snackbar(
    'Success',
    message,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}

void showErrorSnackbar(String message) {
  Get.snackbar(
    'Error',
    message,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

void showInfoSnackbar(String message) {
  Get.snackbar(
    'Info',
    message,
    backgroundColor: AppColors.primaryColor,
    colorText: Colors.white,
  );
}
