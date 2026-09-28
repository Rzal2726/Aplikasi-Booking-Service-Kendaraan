import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/components/buttons/buttonPrimary.dart';
import 'package:project/app/components/cards/badgeBasic.dart';
import 'package:project/app/components/cards/emptyCard.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/routes/app_pages.dart';

import '../controllers/service_screen_controller.dart';

class ServiceScreenView extends GetView<ServiceScreenController> {
  const ServiceScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            controller.loadActivities();
          },
          child: CustomScrollView(
            slivers: [
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _buildSearchBar(),
                ),
              ),

              // Tab filter chips
              SliverToBoxAdapter(child: Obx(() => _buildTabBar())),

              // Activity list or empty state
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                sliver: Obx(() {
                  final list = controller.filteredActivities;
                  if (list.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: EmptyCard(
                          message: controller.selectedTab.value == 0
                              ? "Belum ada servis aktif"
                              : controller.selectedTab.value == 1
                              ? "Tidak ada servis yang sedang dikerjakan"
                              : "Tidak ada servis terjadwal",
                          actionButton: ButtonPrimary(
                            onPressed: () => Get.toNamed(Routes.BOOK_SCREEN),
                            text: "Mulai Booking Servis",
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final activity = list[index] as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildActivityCard(activity),
                      );
                    }, childCount: list.length),
                  );
                }),
              ),
            ],
          ),
        ),

        // Floating "Booking Servis" button at the bottom
        Positioned(bottom: 16, left: 16, right: 16, child: _buildBookingFAB()),
      ],
    );
  }

  // ---- Search Bar ----
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (v) => controller.searchQuery.value = v,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
          suffixIcon: Icon(Icons.tune_rounded, color: AppColors.primaryColor),
          hintText: "Cari booking atau bengkel...",
          hintStyle: const TextStyle(color: Color(0xFFB0B8CC), fontSize: 14),
        ),
      ),
    );
  }

  // ---- Tab Filter Bar ----
  Widget _buildTabBar() {
    final tabs = [
      ("Semua Aktif", controller.activeCount),
      ("Sedang Dikerjakan", controller.ongoingCount),
      ("Terjadwal", controller.scheduledCount),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        spacing: 8,
        children: List.generate(tabs.length, (i) {
          final isSelected = controller.selectedTab.value == i;
          final label = tabs[i].$1;
          final count = tabs[i].$2;
          return GestureDetector(
            onTap: () => controller.selectedTab.value = i,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withAlpha(50),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                spacing: 6,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF64748B),
                    ),
                  ),
                  if (count > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withAlpha(60)
                            : AppColors.primaryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : AppColors.primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---- Activity Card ----
  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final pitAssignments = (activity['pitAssignments'] as List? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final motorCount = pitAssignments.length;
    final code = activity['code'] ?? '';
    final workshop = activity['workshop'] ?? '—';
    final scheduleDate = activity['scheduleDate'] ?? '—';
    final time = activity['time'] ?? '—';
    final status = activity['status'] ?? 'pending';

    // Status badge info
    final (statusLabel, statusColor, statusBg) = _statusInfo(status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: AppColors.backgroundSwatch.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Code
                Text(
                  "#$code",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                // Motor count badge
                _chipSmall(
                  "$motorCount Motor",
                  AppColors.backgroundSwatch.shade400,
                  const Color(0xFF475569),
                ),
                const Spacer(),
                // Status badge
                BasicBadge(
                  backgroundColor: statusBg,
                  content: Row(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Workshop name
                Row(
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      size: 15,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        workshop,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Schedule date + time
                Row(
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: Color(0xFF94A3B8),
                    ),
                    Text(
                      scheduleDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.access_time_outlined,
                      size: 13,
                      color: Color(0xFF94A3B8),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),

                if (pitAssignments.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  // Vehicle / Pit cards
                  ...pitAssignments.asMap().entries.map((entry) {
                    final pitIdx = entry.key;
                    final pit = entry.value;
                    return InkWell(
                      onTap: () => Get.toNamed(
                        Routes.LIVE_TRACKING,
                        arguments: {
                          'id': activity['id'],
                          'activity': activity,
                          'selectedPitIndex': pitIdx,
                        },
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: _buildPitRow(pit),
                    );
                  }),
                  const SizedBox(height: 12),
                ],

                // Live Tracking button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(
                      Routes.LIVE_TRACKING,
                      arguments: {'id': activity['id'], 'activity': activity},
                    ),
                    icon: const Icon(Icons.track_changes_outlined, size: 16),
                    label: const Text(
                      "Live Tracking",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Action buttons
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(
                          Routes.BOOK_CONFIRM,
                          arguments: {
                            'id': activity['id'],
                            'activity': activity,
                          },
                        ),
                        icon: const Icon(Icons.receipt_long_outlined, size: 15),
                        label: const Text(
                          "Bukti Servis",
                          style: TextStyle(fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          side: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPitRow(Map<String, dynamic> pit) {
    final vehicleName = pit['vehicleName'] ?? '—';
    final plate = pit['plateNumber'] ?? '';
    final pitLabel = pit['pit'] ?? '';
    final mechanic = pit['mechanic'] ?? '';
    final statusVal = (pit['status'] as num?)?.toInt() ?? 0;
    final progressVal = (statusVal / 5.0).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSwatch.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  vehicleName,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              _chipSmall(
                "${(progressVal * 100).toInt()}% Selesai",
                AppColors.primaryColor.shade100,
                AppColors.primaryColor.shade800,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            spacing: 6,
            children: [
              _plateChip(plate),
              Text(
                "• $pitLabel",
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              if (mechanic.isNotEmpty) ...[
                const Text(
                  "•",
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
                Expanded(
                  child: Text(
                    mechanic,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressVal,
            color: AppColors.primaryColor.shade800,
            backgroundColor: AppColors.backgroundSwatch.shade300,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _plateChip(String plate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.backgroundSwatch.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        plate,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _chipSmall(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }

  (String, Color, Color) _statusInfo(String status) {
    switch (status) {
      case 'pending':
        return (
          "Sedang Dikerjakan",
          const Color(0xFFD97706),
          const Color(0xFFFFFBEB),
        );
      case 'scheduled':
        return ("Terjadwal", const Color(0xFF3B82F6), const Color(0xFFEFF6FF));
      case 'COMPLETED':
        return ("Selesai", const Color(0xFF10B981), const Color(0xFFF0FDF4));
      default:
        return (
          "Aktif",
          AppColors.primaryColor,
          AppColors.primaryColor.shade100,
        );
    }
  }

  // ---- Floating Booking Button ----
  Widget _buildBookingFAB() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => Get.toNamed(Routes.BOOK_SCREEN),
        icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
        label: const Text(
          "Booking Servis Baru",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
