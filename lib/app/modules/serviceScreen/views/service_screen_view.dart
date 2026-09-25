import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/service_screen_controller.dart';

class ServiceScreenView extends GetView<ServiceScreenController> {
  const ServiceScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ServiceScreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ServiceScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
