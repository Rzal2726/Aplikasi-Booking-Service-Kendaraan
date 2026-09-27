import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:project/app/const/appcolors.dart';

import '../controllers/service_screen_controller.dart';

class ServiceScreenView extends GetView<ServiceScreenController> {
  const ServiceScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 8.0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: Icon(Icons.tune, color: AppColors.primaryColor),
                hintText: "Cari Booking",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
