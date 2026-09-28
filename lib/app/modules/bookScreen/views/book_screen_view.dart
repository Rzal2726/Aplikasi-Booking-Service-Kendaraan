import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/components/appbar/bookAppbar.dart';
import 'package:project/app/components/buttons/buttonPrimary.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/modules/bookReview/views/book_review_view.dart';
import 'package:project/app/modules/bookSchedule/views/book_schedule_view.dart';
import 'package:project/app/modules/bookService/views/book_service_view.dart';
import 'package:project/app/modules/bookVehicle/views/book_vehicle_view.dart';
import 'package:project/app/services/formatter.dart';
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
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(() {
            final pageIndex = controller.pageIndex.value;
            String title;
            switch (pageIndex) {
              case 0:
                title = "Pilih Motor";
                break;
              case 1:
                title = "Pilih Layanan";
                break;
              case 2:
                title = "Pilih Jadwal";
                break;
              case 3:
                title = "Review";
                break;
              default:
                title = "Pilih Layanan";
            }
            return BookAppbar(
              title: title,
              showBackButton: true,
              onBack: () {
                if (controller.pageIndex.value > 0) {
                  controller.prevPage();
                } else {
                  Get.back();
                }
              },
            );
          }),
        ),
        bottomNavigationBar: Obx(() => _buildBottomBar()),
        body: SafeArea(
          child: Obx(() {
            final pageIndex = controller.pageIndex.value;
            return Column(
              children: [
                _buildSteps(),
                Expanded(child: _buildScreen(pageIndex)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final pageIndex = controller.pageIndex.value;

    if (pageIndex == 1) {
      // Step 2 (Layanan) Bottom Bar matching the screenshot
      return Obx(() {
        final motorCount = controller.serviceController.selectedVehicle.length;
        final totalPrice = controller.serviceController.totalPrice;
        final totalMinutes =
            controller.serviceController.totalEstimatedMinutes;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Total Information
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Estimasi ($motorCount Motor):",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatRupiah(totalPrice),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              "Pengerjaan Paralel ($motorCount Pit) • ~$totalMinutes Menit",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // "Lanjut ke Jadwal ->" Button
                Material(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => controller.nextPage(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Lanjut ke Jadwal",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }

    if (pageIndex == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8.0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    "${controller.vehicleController.selectedVehicle.length} Motor Dipilih",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
              ButtonPrimary(
                onPressed: () {
                  controller.nextPage();
                },
                text: "Lanjut Atur",
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (pageIndex == 2) {
      // Step 3 (Jadwal) Bottom Bar matching the screenshot
      return Obx(() {
        final motorCount = controller.serviceController.selectedVehicle.length;
        final totalPrice = controller.serviceController.totalPrice;
        final isParallel =
            controller.scheduleController.workMethod.value == 'parallel';
        final methodText = isParallel
            ? "Pengerjaan Paralel ($motorCount Pit)"
            : "Pengerjaan Berurutan (1 Pit)";

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Estimasi ($motorCount Motor):",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatRupiah(totalPrice),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              methodText,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => controller.nextPage(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Lanjut ke Review",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }

    // Step 4 (Review) Bottom Bar matching the screenshot
    return Obx(() {
      final motorCount = controller.serviceController.selectedVehicle.length;
      final totalPay = controller.reviewController.totalPayment;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Bayar",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatRupiah(totalPay),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "$motorCount Motor • Hemat 60 mnt",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => controller.reviewController.confirmBooking(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Konfirmasi Booking",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.verified_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const BookVehicleView();
      case 1:
        return const BookServiceView();
      case 2:
        return const BookScheduleView();
      case 3:
        return const BookReviewView();
      default:
        return const BookVehicleView();
    }
  }

  Widget _buildSteps() {
    final steps = ['1. Motor', '2. Layanan', '3. Jadwal', '4. Review'];
    final currentIndex = controller.pageIndex.value;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final stepCount = steps.length;
          final circleSize = 30.0;
          final spacing = (totalWidth - (circleSize * stepCount)) / (stepCount - 1);

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // Connecting line segments between steps
              Positioned(
                top: circleSize / 2 - 1,
                left: circleSize / 2,
                right: circleSize / 2,
                child: Row(
                  children: List.generate(stepCount - 1, (i) {
                    // Line i connects step i and step i + 1
                    final isLineActive = i < currentIndex;
                    return Expanded(
                      child: Container(
                        height: 2,
                        color: isLineActive
                            ? AppColors.primaryColor
                            : const Color(0xFFE2E8F0),
                      ),
                    );
                  }),
                ),
              ),
              // Step Circles & Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(stepCount, (index) {
                  final isPassed = index < currentIndex;
                  final isActive = index == currentIndex;

                  Color circleBg;
                  Color borderColor;
                  Widget iconOrText;

                  if (isPassed) {
                    circleBg = const Color(0xFF10B981); // Green for completed
                    borderColor = const Color(0xFF10B981);
                    iconOrText = const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    );
                  } else if (isActive) {
                    circleBg = AppColors.primaryColor;
                    borderColor = AppColors.primaryColor;
                    iconOrText = Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    circleBg = const Color(0xFFF1F5F9);
                    borderColor = const Color(0xFFE2E8F0);
                    iconOrText = Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94A3B8),
                      ),
                    );
                  }

                  Color labelColor;
                  FontWeight labelWeight;
                  if (isActive) {
                    labelColor = AppColors.primaryColor;
                    labelWeight = FontWeight.bold;
                  } else if (isPassed) {
                    labelColor = const Color(0xFF0F172A);
                    labelWeight = FontWeight.w600;
                  } else {
                    labelColor = const Color(0xFF94A3B8);
                    labelWeight = FontWeight.normal;
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: circleBg,
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Center(child: iconOrText),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        steps[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: labelWeight,
                          color: labelColor,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
