import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/const/appcolors.dart';
import '../controllers/book_schedule_controller.dart';

class BookScheduleView extends GetView<BookScheduleController> {
  const BookScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final motorCount = controller.serviceController.selectedVehicle.length;

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _buildWorkshopCard(),
          const SizedBox(height: 16),
          if (motorCount >= 2) ...[
            _buildWorkMethodCard(),
            const SizedBox(height: 16),
          ],
          _buildDatePickerCard(),
          const SizedBox(height: 16),
          _buildTimeSlotsCard(),
          const SizedBox(height: 16),
          _buildPitMechanicAllocationCard(),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  // --- Section 1: Workshop Information Card ---
  Widget _buildWorkshopCard() {
    return Obx(() {
      final motorCount = controller.serviceController.selectedVehicle.length;
      final pitCount = int.tryParse(
            controller.workshopActivePits.value.replaceAll(RegExp(r'[^0-9]'), ''),
          ) ??
          0;
      final supportsParallel = pitCount >= 2 && motorCount >= 2;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Workshop Storefront Icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: AppColors.primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              controller.workshopName.value,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF10B981),
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        controller.workshopAddress.value,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // "Ganti Workshop" Button
                GestureDetector(
                  onTap: () => _showWorkshopBottomSheet(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1EB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swap_horiz_rounded,
                          color: AppColors.primaryColor,
                          size: 13,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Ganti",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // 3 Info Chips Row
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.star_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: controller.workshopRating.value,
                    subtitle: controller.workshopReviews.value,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.near_me_outlined,
                    iconColor: const Color(0xFF64748B),
                    title: controller.workshopDistance.value,
                    subtitle: controller.workshopTravelTime.value,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.precision_manufacturing_outlined,
                    iconColor: const Color(0xFF0D9488),
                    title: controller.workshopActivePits.value,
                    subtitle: controller.workshopPitEquip.value,
                  ),
                ),
              ],
            ),
            if (motorCount >= 2) ...[
              const SizedBox(height: 12),
              // Green / Yellow Banner depending on pit support
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: supportsParallel
                      ? const Color(0xFFF0FDF4)
                      : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: supportsParallel
                        ? const Color(0xFFBBF7D0)
                        : const Color(0xFFFDE68A),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      supportsParallel
                          ? Icons.check_circle_outline_rounded
                          : Icons.info_outline_rounded,
                      color: supportsParallel
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFD97706),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        supportsParallel
                            ? "Bengkel ini mendukung pengerjaan serentak $pitCount pit"
                            : "Bengkel ini hanya memiliki $pitCount pit aktif",
                        style: TextStyle(
                          color: supportsParallel
                              ? const Color(0xFF15803D)
                              : const Color(0xFF92400E),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: supportsParallel
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFFFDE68A),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Tersedia",
                        style: TextStyle(
                          color: supportsParallel
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFD97706),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildInfoChip({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 14),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- Workshop Selection Bottom Sheet ---
  void _showWorkshopBottomSheet() {
    final workshops = controller.workshopsList;
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                "Pilih Workshop",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Pilih bengkel MotoServ terdekat dari kamu",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 14),
              if (workshops.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "Tidak ada bengkel tersedia.",
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ),
                )
              else
                ...workshops.map((w) {
                  final isSelected =
                      controller.selectedWorkshopId.value == w['id'];
                  final pitCount = w['pit'] ?? 0;
                  final ratingRaw = (w['rating'] ?? '4.9').toString().replaceAll(',', '.');
                  final distanceText = w['distance'] != null
                      ? '${w['distance']}'
                      : (w['id'] == 2 ? '12.4 km' : '2.4 km');

                  return GestureDetector(
                    onTap: () {
                      Get.back();
                      controller.selectWorkshop(w);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFF8F5)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFF1EB)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.storefront_outlined,
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : const Color(0xFF64748B),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  w['name'] ?? '-',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  w['address'] ?? '-',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 12,
                                      color: Color(0xFFF59E0B),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      ratingRaw,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.precision_manufacturing_outlined,
                                      size: 12,
                                      color: Color(0xFF0D9488),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      "$pitCount Pit",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.near_me_outlined,
                                      size: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      distanceText,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Check icon if selected
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // --- Section 2: Metode Pengerjaan Card ---
  Widget _buildWorkMethodCard() {
    return Obx(() {
      final isParallel = controller.workMethod.value == 'parallel';

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  "Metode Pengerjaan",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Spacer(),
                Text(
                  "Pilih alokasi pit pengerjaan",
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Option 1: Pengerjaan Paralel (2 Pit)
            GestureDetector(
              onTap: () => controller.setWorkMethod('parallel'),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isParallel
                        ? AppColors.primaryColor
                        : const Color(0xFFE2E8F0),
                    width: isParallel ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Radio circle
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isParallel
                                ? AppColors.primaryColor
                                : Colors.transparent,
                            border: isParallel
                                ? null
                                : Border.all(
                                    color: const Color(0xFFCBD5E1),
                                    width: 1.5,
                                  ),
                          ),
                          child: isParallel
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Pengerjaan Paralel (2 Pit)",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Rekomendasi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "2 Motor dikerjakan bersamaan di pit terpisah.",
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "Hemat ~60 Menit",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "• Total durasi: 60 Menit",
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Option 2: Pengerjaan Berurutan (1 Pit)
            GestureDetector(
              onTap: () => controller.setWorkMethod('sequential'),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: !isParallel
                        ? AppColors.primaryColor
                        : const Color(0xFFE2E8F0),
                    width: !isParallel ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: !isParallel
                                ? AppColors.primaryColor
                                : Colors.transparent,
                            border: !isParallel
                                ? null
                                : Border.all(
                                    color: const Color(0xFFCBD5E1),
                                    width: 1.5,
                                  ),
                          ),
                          child: !isParallel
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Pengerjaan Berurutan (1 Pit)",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "Satu pit bergantian mekanik yang sama. Total durasi: 120 Menit (2 Jam).",
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // --- Section 3: Date Picker Card ---
  Widget _buildDatePickerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                controller.selectedMonthYear.value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              const Text(
                "Pilih hari kunjungan",
                style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Horizontal Dates Row
          Obx(() {
            final selectedIdx = controller.selectedDateIndex.value;
            final dates = controller.availableDates;

            return Row(
              children: List.generate(dates.length, (i) {
                final dateItem = dates[i];
                final isSelected = i == selectedIdx;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.selectDate(i),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: i == 0 ? 0 : 4,
                        right: i == dates.length - 1 ? 0 : 4,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dateItem['day'] ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white.withOpacity(0.9)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateItem['date'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isSelected ? "Pilihan" : (dateItem['status'] ?? ''),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  // --- Section 4: Time Slots Card ---
  Widget _buildTimeSlotsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                "Pilih Jam Kedatangan",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Zona WIB",
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sesi Pagi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "SESI PAGI (08:00 - 11:30)",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                ),
              ),
              const Text(
                "2 Pit Tersedia",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSlotItem("08:30", "Tersedia", available: true),
              const SizedBox(width: 8),
              _buildSlotItem("09:30", "2 Pit Siap", available: true),
              const SizedBox(width: 8),
              _buildSlotItem("10:30", "Tersedia", available: true),
            ],
          ),
          const SizedBox(height: 14),
          // Sesi Siang
          const Text(
            "SESI SIANG (12:30 - 15:00)",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSlotItem("13:00", "Tersedia", available: true),
              const SizedBox(width: 8),
              _buildSlotItem(
                "14:00",
                "Sisa 1 Pit",
                statusColor: const Color(0xFFEA580C),
                available: true,
              ),
              const SizedBox(width: 8),
              _buildSlotItem("Istirahat Bay", "", disabled: true),
            ],
          ),
          const SizedBox(height: 14),
          // Sesi Sore
          const Text(
            "SESI SORE (15:00 - 17:00)",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSlotItem("15:30", "Tersedia", available: true),
              const SizedBox(width: 8),
              _buildSlotItem("16:30", "Tersedia", available: true),
              const SizedBox(width: 8),
              _buildSlotItem("Closing Bay", "", disabled: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlotItem(
    String time,
    String subtitle, {
    bool available = false,
    bool disabled = false,
    Color? statusColor,
  }) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedTimeSlot.value == time;

        if (disabled) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Center(
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () => controller.selectTimeSlot(time),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white.withOpacity(0.9)
                          : (statusColor ?? const Color(0xFF16A34A)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- Section 5: Pit and Mechanic Allocation Card ---
  Widget _buildPitMechanicAllocationCard() {
    return Obx(() {
      final assignments = controller.pitAssignments;
      final motorCount = assignments.length;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1EB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.engineering_outlined,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  motorCount > 1
                      ? "Alokasi Pit & Mekanik ($motorCount Motor)"
                      : "Alokasi Pit & Mekanik",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // List of Pit Assignments
            ...assignments.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    // Pit Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1EB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['pit'] ?? '',
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item['vehicleName'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['plateNumber'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF475569),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${item['pit']} • Mekanik: ${item['mechanic']} • ${item['time']}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // "Terjadwal" Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Terjadwal",
                        style: TextStyle(
                          color: Color(0xFF16A34A),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 4),
            // Green Summary Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF16A34A),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.estimatedEndTimeText,
                      style: const TextStyle(
                        color: Color(0xFF15803D),
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
