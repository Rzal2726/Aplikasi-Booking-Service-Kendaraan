import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/activity_screen_controller.dart';

class ActivityScreenView extends GetView<ActivityScreenController> {
  const ActivityScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActivityScreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ActivityScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
