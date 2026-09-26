import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/components/mainAppbar.dart';
import 'package:project/app/const/appcolors.dart';

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
                'Halo User!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Card Title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('This is a basic card with some content.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceSummary() {
    return Container();
  }

  Widget activitySummary() {
    return Container();
  }
}
