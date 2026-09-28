import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project/app/components/appbar/homeAppbar.dart';
import 'package:project/app/components/buttons/buttonPrimary.dart';
import 'package:project/app/components/cards/badgeBasic.dart';
import 'package:project/app/components/cards/cardBasic.dart';
import 'package:project/app/components/cards/emptyCard.dart';
import 'package:project/app/components/mainAppbar.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/modules/accountScreen/views/account_screen_view.dart';
import 'package:project/app/modules/activityScreen/views/activity_screen_view.dart';
import 'package:project/app/modules/garageScreen/views/garage_screen_view.dart';
import 'package:project/app/modules/serviceScreen/views/service_screen_view.dart';
import 'package:project/app/routes/app_pages.dart';

import '../controllers/home_screen_controller.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  const HomeScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (controller.pageIndex.value != 0) {
          controller.pageIndex.value = 0;
        } else {
          Get.dialog(
            Dialog(
              backgroundColor: Colors.white,
              child: BasicCard(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.logout,
                        size: 40,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Title
                    Text(
                      "Keluar",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6.0),

                    // Message Body
                    Text(
                      "Apakah anda yakin ingin keluar dari aplikasi?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: ButtonPrimary(
                            color: Colors.white,
                            textColor: AppColors.primaryColor,
                            onPressed: () {
                              Get.back();
                            },
                            text: "Tidak",
                          ),
                        ),
                        Expanded(
                          child: ButtonPrimary(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            text: "Ya",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundSwatch,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Obx(() => HomeAppbar(title: controller.appBarTitle.value)),
        ),
        bottomNavigationBar: navBar(),
        body: Obx(() {
          final index = controller.pageIndex.value;
          if (index == 0) {
            return homeScreen();
          } else if (index == 1) {
            return ServiceScreenView();
          } else if (index == 2) {
            return GarageScreenView();
          } else if (index == 3) {
            return ActivityScreenView();
          } else if (index == 4) {
            return AccountScreenView();
          } else {
            return homeScreen();
          }
        }),
      ),
    );
  }

  Widget homeScreen() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          // Implement your refresh logic here
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Halo, User!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Mau servis apa hari ini?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600]!,
                        ),
                      ),
                    ],
                  ),
                ),
                BasicBadge(
                  content: Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.two_wheeler_outlined,
                        size: 16,
                        color: Colors.grey.shade700,
                      ),
                      Text(
                        '2 Motor Terdaftar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.backgroundSwatch.shade200,
                ),
              ],
            ),
            const SizedBox(height: 16),
            bookCard(),
            const SizedBox(height: 16),
            // shortcutList(),
            // const SizedBox(height: 16),
            serviceSummary(),
            const SizedBox(height: 16),

            garageSummary(),
            const SizedBox(height: 16),
            activitySummary(),
          ],
        ),
      ),
    );
  }

  Widget navBar() {
    Widget actionButton({
      required IconData icon,
      required String label,
      required Function() onPressed,
      required bool isActive,
    }) {
      return Expanded(
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? AppColors.primaryColor.shade800
                      : Colors.grey[600],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive
                        ? AppColors.primaryColor.shade800
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(
            () => actionButton(
              icon: Icons.home_outlined,
              label: "Home",
              onPressed: () {
                controller.pageIndex.value = 0;
              },
              isActive: controller.pageIndex.value == 0,
            ),
          ),
          Obx(
            () => actionButton(
              icon: Icons.build_outlined,
              label: "Servis",
              onPressed: () {
                controller.pageIndex.value = 1;
              },
              isActive: controller.pageIndex.value == 1,
            ),
          ),
          Obx(
            () => actionButton(
              icon: Icons.two_wheeler_outlined,
              label: "Garasi",
              onPressed: () {
                controller.pageIndex.value = 2;
              },
              isActive: controller.pageIndex.value == 2,
            ),
          ),
          Obx(
            () => actionButton(
              icon: Icons.article_outlined,
              label: "Aktivitas",
              onPressed: () {
                controller.pageIndex.value = 3;
              },
              isActive: controller.pageIndex.value == 3,
            ),
          ),
          Obx(
            () => actionButton(
              icon: Icons.account_circle_outlined,
              label: "Akun",
              onPressed: () {
                controller.pageIndex.value = 4;
              },
              isActive: controller.pageIndex.value == 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget bookCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.shade800,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 300,
            top: 80,
            child: ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: AppColors.primaryColor.shade700,
                ),
                width: 150,
                height: 150,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 32,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(50),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flash_on_outlined,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'PRIORITAS PIT PARAREL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Booking Servis Sekarang',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Multi-motor hemat waktu hingga 50% di bengkel mitra resmi.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Icon(
                        Icons.two_wheeler_outlined,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ButtonPrimary(
                    onPressed: () {
                      Get.toNamed(Routes.BOOK_SCREEN);
                    },
                    text: 'Mulai Booking Servis',
                    color: Colors.white,
                    textColor: AppColors.primaryColor.shade800,
                    icon: Icon(
                      Icons.arrow_forward,
                      color: AppColors.primaryColor.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shortcutList() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: shortcutButton(
              text: "Servis\nBerkala",
              icon: Icons.settings,
              onTap: () {
                Get.toNamed(Routes.BOOK_SCREEN);
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: shortcutButton(
              text: "Ganti\nOli Kilat",
              icon: Icons.oil_barrel,
              onTap: () {
                Get.toNamed(Routes.BOOK_SCREEN);
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: shortcutButton(
              text: "Servis CVT",
              icon: Icons.tune,
              onTap: () {
                Get.toNamed(Routes.BOOK_SCREEN);
              },
            ),
          ),
          // const SizedBox(width: 8.0),
          // Expanded(
          //   child: shortcutButton(
          //     text: "Darurat\n/Mogok",
          //     icon: Icons.car_repair,
          //     onTap: () {
          //       Get.toNamed(Routes.BOOK_SCREEN);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget shortcutButton({
    required String text,
    required IconData icon,
    Color? textColor,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.backgroundSwatch.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(icon, color: AppColors.primaryColor.shade800),
            ),
            const SizedBox(height: 8.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: textColor ?? Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceSummary() {
    return Container(
      child: Column(
        spacing: 16,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  "Servis Berlangsung",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),

              BasicBadge(
                backgroundColor: AppColors.primaryColor.withAlpha(25),
                content: Row(
                  spacing: 4,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor.shade800,
                      ),
                    ),
                    Text(
                      "Sedang Dikerjakan",
                      style: TextStyle(color: AppColors.primaryColor.shade800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(() {
            final serviceList = controller.serviceController.serviceList;
            if (serviceList.isEmpty) {
              return EmptyCard(
                message: "Tidak ada servis yang sedang berlangsung",
                actionButton: ButtonPrimary(
                  onPressed: () {
                    Get.toNamed(Routes.BOOK_SCREEN);
                  },
                  text: "Mulai Booking Servis",
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  Widget garageSummary() {
    return Container(
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  "Kendaraan Saya",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.pageIndex.value = 2;
                },
                child: Container(
                  child: Text(
                    "Kelola Garasi",
                    style: TextStyle(
                      color: AppColors.primaryColor.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            final vehicleList = controller.garageController.vehicleList;
            if (vehicleList.isEmpty) {
              return EmptyCard(
                message: "Tidak ada kendaraan yang terdaftar",
                actionButton: ButtonPrimary(
                  onPressed: () {},
                  text: "Tambahkan Kendaraan",
                  icon: Icon(Icons.add_circle_outline, color: Colors.white),
                ),
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  Widget activitySummary() {
    return Container(
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  "Riwayat Booking",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.pageIndex.value = 3;
                },
                child: Container(
                  child: Text(
                    "Lihat Semua",
                    style: TextStyle(
                      color: AppColors.primaryColor.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            final activityList = controller.activityController.activityList;
            if (activityList.isEmpty) {
              return EmptyCard(
                message: "Belum ada aktivitas",
                actionButton: ButtonPrimary(
                  onPressed: () {
                    Get.toNamed(Routes.BOOK_SCREEN);
                  },
                  text: "Mulai Booking Servis",
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }
}
