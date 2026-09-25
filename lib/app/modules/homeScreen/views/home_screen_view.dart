import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/components/mainAppbar.dart';

import '../controllers/home_screen_controller.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  const HomeScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(title: 'Home'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Implement your refresh logic here
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                'Welcome to the Home Screen!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to another screen
                  Get.toNamed('/service-screen');
                },
                child: const Text('Go to Service Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
