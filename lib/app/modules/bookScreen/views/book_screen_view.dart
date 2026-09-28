import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:project/app/components/appbar/bookAppbar.dart';
import 'package:project/app/components/buttons/buttonPrimary.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/modules/bookReview/views/book_review_view.dart';
import 'package:project/app/modules/bookSchedule/views/book_schedule_view.dart';
import 'package:project/app/modules/bookService/views/book_service_view.dart';
import 'package:project/app/modules/bookVehicle/views/book_vehicle_view.dart';

import '../controllers/book_screen_controller.dart';

class BookScreenView extends GetView<BookScreenController> {
  const BookScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (controller.pageIndex.value > 0) {
            controller.prevPage();
          } else {
            Get.back();
          }
        }
      },
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundSwatch,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: BookAppbar(
            title: "Pilih Motor",
            onBack: () {
              if (controller.pageIndex.value > 0) {
                controller.prevPage();
              } else {
                Get.back();
              }
            },
          ),
        ),
        bottomNavigationBar: Obx(() {
          final pageIndex = controller.pageIndex.value;
          return selectVehicleBottomNav();
        }),
        body: SafeArea(
          child: Obx(() {
            final pageIndex = controller.pageIndex.value;
            return Column(
              children: [
                buildSteps(),
                Expanded(child: buildScreen(pageIndex)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget selectVehicleBottomNav() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8.0,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      "${controller.vehicleController.selectedVehicle.length} Motor Dipilih",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                ButtonPrimary(
                  onPressed: () {
                    controller.nextPage();
                  },
                  text: "Lanjut Atur",
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScreen(index) {
    switch (index) {
      case 0:
        return BookVehicleView();
      case 1:
        return BookServiceView();
      case 2:
        return BookScheduleView();
      case 3:
        return BookReviewView();
      default:
        return BookVehicleView();
    }
  }

  Widget buildSteps() {
    final steps = ['1.Motor', '2.Layanan', '3.Jadwal', '4.Konfirmasi'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Connecting Line behind steps
          Positioned(
            top: 16,
            left: 32,
            right: 32,
            child: Container(height: 2, color: Colors.grey.shade200),
          ),
          // Step Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              final stepNumber = index;
              final isActive = stepNumber == controller.pageIndex.value;
              final isPassed = stepNumber < controller.pageIndex.value;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circle
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.primaryColor
                          : (!isPassed ? Colors.grey.shade100 : Colors.green),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primaryColor.shade100
                            : (!isPassed ? Colors.grey.shade100 : Colors.green),
                        width: isActive ? 2 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: isPassed
                          ? Icon(Icons.check, color: Colors.white)
                          : Text(
                              '${stepNumber + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isActive
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Label
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isActive
                          ? AppColors.primaryColor
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
