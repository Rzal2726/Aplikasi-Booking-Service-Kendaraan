import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/garage_screen_controller.dart';

class GarageScreenView extends GetView<GarageScreenController> {
  const GarageScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GarageScreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GarageScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
