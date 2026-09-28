import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/services/formatter.dart';
import '../controllers/live_tracking_controller.dart';

class LiveTrackingView extends GetView<LiveTrackingController> {
  const LiveTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.activity.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        return _buildBody();
      }),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
        onPressed: () => Get.back(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.two_wheeler, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          const Text(
            'Status Servis',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  // ── Body ─────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Booking header banner
          _buildBookingBanner(),
          const SizedBox(height: 16),

          // 2. Filter tabs (Semua, Sedang Dikerjakan, Menunggu, Selesai)
          _buildFilterTabs(),
          const SizedBox(height: 16),

          // 3. All vehicles in a list (matching selected filter)
          _buildVehiclesList(),
          const SizedBox(height: 16),

          // 4. Service advisor card
          // _buildAdvisorCard(),
          // const SizedBox(height: 16),

          // 7. Cost summary
          _buildCostSummary(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── 1. Booking Banner ────────────────────────────────────────────────────
  Widget _buildBookingBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      'BOOKING #${controller.bookingCode}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBE5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.primaryColor.shade200,
                        ),
                      ),
                      child: Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                          const Text(
                            'LIVE MONITORING',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  spacing: 4,
                  children: [
                    const Icon(
                      Icons.sync_rounded,
                      size: 13,
                      color: Color(0xFF64748B),
                    ),
                    Text(
                      'Diperbarui 2 menit yang lalu  •  ${controller.pitAssignments.length} Mekanik sedang aktif',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
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

  // ── 2. Filter Tabs ────────────────────────────────────────────────────────
  Widget _buildFilterTabs() {
    return Obx(() {
      final tabs = [
        ('Semua', controller.allCount),
        ('Dikerjakan', controller.inProgressCount),
        ('Menunggu', controller.waitingCount),
        ('Selesai', controller.completedCount),
      ];
      final currentTab = controller.selectedFilterTab.value;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (i) {
            final (label, count) = tabs[i];
            final isSelected = currentTab == i;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => controller.setFilterTab(i),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.25,
                              ),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.25)
                              : AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryColor.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  // ── 3. Vehicles List ──────────────────────────────────────────────────────
  Widget _buildVehiclesList() {
    return Obx(() {
      final list = controller.filteredPitAssignments;
      if (list.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.two_wheeler_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              const Text(
                'Tidak ada kendaraan dengan status ini',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => controller.setFilterTab(0),
                child: const Text('Tampilkan Semua Kendaraan'),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Daftar Kendaraan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryColor.shade200),
                ),
                child: Text(
                  '${list.length} Motor',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...list.map((pit) {
            final originalIdx = controller.pitAssignments.indexOf(pit);
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildVehicleCard(pit, originalIdx >= 0 ? originalIdx : 0),
            );
          }),
        ],
      );
    });
  }

  // ── Vehicle Card ──────────────────────────────────────────────────────────
  Widget _buildVehicleCard(Map<String, dynamic> pit, int pitIndex) {
    final vehicleName = pit['vehicleName'] ?? '—';
    final plate = pit['plateNumber'] ?? '';
    final pitLabel = pit['pit'] ?? '';
    final mechanic = pit['mechanic'] ?? '';
    final statusVal = (pit['status'] as num?)?.toInt() ?? 0;
    final steps = controller.statusSteps;
    final stepIdx = (statusVal - 1).clamp(0, steps.length - 1);
    final stepLabel = (statusVal > 0 && statusVal <= steps.length)
        ? steps[stepIdx]['status'] as String
        : '—';
    final progressVal = (statusVal / 5.0).clamp(0.0, 1.0);

    // Get package label from vehicleActivities by index
    String packageLabel = '—';
    final vehicleActivities = controller.vehicleActivities;
    if (pitIndex < vehicleActivities.length) {
      final va = vehicleActivities[pitIndex];
      final sids = (va['serviceIds'] as List?)?.cast<dynamic>() ?? [];
      packageLabel = controller.buildPackageLabel(sids);
    }

    return Obx(() {
      final isExpanded = controller.isTimelineExpanded(pitIndex);
      final isFocused = controller.selectedPitIndex.value == pitIndex;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFocused
                ? AppColors.primaryColor.shade300
                : const Color(0xFFE2E8F0),
            width: isFocused ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundSwatch.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  _plateChip(plate),
                  const SizedBox(width: 8),
                  Text(
                    pitLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const Spacer(),
                  _statusBadge(stepLabel, stepIdx),
                ],
              ),
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Name
                  Text(
                    vehicleName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Mechanic row
                  if (mechanic.isNotEmpty) ...[
                    Row(
                      spacing: 6,
                      children: [
                        const Icon(
                          Icons.engineering_outlined,
                          size: 15,
                          color: Color(0xFF64748B),
                        ),
                        Text(
                          'Mekanik: $mechanic',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],

                  // Estimated completion time
                  Row(
                    spacing: 6,
                    children: [
                      const Icon(
                        Icons.access_time_outlined,
                        size: 15,
                        color: Color(0xFF64748B),
                      ),
                      Text(
                        'Est. Selesai: ${pit['time'] ?? '—'}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (statusVal < 5)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '~20 mnt lagi',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Selesai',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Package / Services row
                  if (packageLabel != '—') ...[
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.build_outlined,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            packageLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progressVal,
                      color: AppColors.primaryColor,
                      backgroundColor: AppColors.primaryColor.shade100,
                      minHeight: 7,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progressVal * 100).toInt()}% Selesai',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor.shade700,
                        ),
                      ),
                      Text(
                        'Langkah $statusVal dari ${steps.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Mini step indicator
                  _buildMiniTimeline(statusVal),

                  const SizedBox(height: 10),

                  // Toggle expandable full timeline
                  InkWell(
                    onTap: () => controller.toggleTimelineExpanded(pitIndex),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 6,
                            children: [
                              Icon(
                                Icons.format_list_bulleted_rounded,
                                size: 14,
                                color: AppColors.primaryColor.shade700,
                              ),
                              Text(
                                isExpanded
                                    ? 'Sembunyikan Progres Lengkap'
                                    : 'Lihat Progres Lengkap (5 Tahap)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor.shade700,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.primaryColor.shade700,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expanded full timeline
                  if (isExpanded) _buildVehicleTimeline(pit),

                  // const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Vehicle Timeline ─────────────────────────────────────────────────────
  Widget _buildVehicleTimeline(Map<String, dynamic> pit) {
    final steps = controller.statusSteps;
    final statusVal = (pit['status'] as num?)?.toInt() ?? 0;
    final currentIdx = (statusVal - 1).clamp(0, steps.length - 1);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            final isDone = i < currentIdx;
            final isActive = i == currentIdx;
            final isUpcoming = i > currentIdx;
            final isLast = i == steps.length - 1;
            final detail = controller.getVehicleStepDetail(pit, i);

            return _buildTimelineItem(
              stepNumber: i + 1,
              label: step['status'] as String? ?? '—',
              detail: detail,
              isDone: isDone,
              isActive: isActive,
              isUpcoming: isUpcoming,
              isLast: isLast,
              time: isActive ? (pit['time'] ?? '') : '',
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required int stepNumber,
    required String label,
    required String detail,
    required bool isDone,
    required bool isActive,
    required bool isUpcoming,
    required bool isLast,
    String time = '',
  }) {
    final Color dotColor;
    final Color lineColor;
    final Widget dotContent;

    if (isDone) {
      dotColor = const Color(0xFF10B981);
      lineColor = const Color(0xFF10B981);
      dotContent = const Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 14,
      );
    } else if (isActive) {
      dotColor = AppColors.primaryColor;
      lineColor = const Color(0xFFE2E8F0);
      dotContent = Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      );
    } else {
      dotColor = const Color(0xFFE2E8F0);
      lineColor = const Color(0xFFE2E8F0);
      dotContent = Text(
        stepNumber.toString(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF94A3B8),
        ),
      );
    }

    final labelColor = isDone
        ? const Color(0xFF10B981)
        : isActive
        ? const Color(0xFF0F172A)
        : const Color(0xFF94A3B8);
    final labelWeight = isActive ? FontWeight.bold : FontWeight.w500;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + vertical line
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Center(child: dotContent),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: lineColor,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Text content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: labelWeight,
                            color: labelColor,
                          ),
                        ),
                      ),
                      if (time.isNotEmpty && isActive)
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor.shade700,
                          ),
                        ),
                    ],
                  ),
                  if (detail.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      detail,
                      style: TextStyle(
                        fontSize: 12,
                        color: isUpcoming
                            ? const Color(0xFFB0BEC5)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTimeline(int currentStatusVal) {
    final steps = controller.statusSteps;
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // connector line
          final stepIdx = i ~/ 2;
          final isDone = stepIdx < currentStatusVal - 1;
          return Expanded(
            child: Container(
              height: 2,
              color: isDone ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final isDone = stepIdx < currentStatusVal - 1;
        final isActive = stepIdx == currentStatusVal - 1;
        final Color dotColor = isDone
            ? const Color(0xFF10B981)
            : isActive
            ? AppColors.primaryColor
            : const Color(0xFFE2E8F0);
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                : Text(
                    (stepIdx + 1).toString(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : const Color(0xFF94A3B8),
                    ),
                  ),
          ),
        );
      }),
    );
  }

  // ── 6. Service Advisor Card ──────────────────────────────────────────────
  Widget _buildAdvisorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.shade100,
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  color: AppColors.primaryColor,
                  size: 26,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pak Teknisi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Service Advisor ${controller.workshopName.split(' ').take(2).join(' ')}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Ada pertanyaan teknis atau ingin menambahkan rekomendasi servis untuk salah satu motor Anda? Hubungi langsung.',
            style: TextStyle(fontSize: 12.5, color: Color(0xFF374151)),
          ),
          const SizedBox(height: 14),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call_outlined, size: 15),
                  label: const Text(
                    'Telepon Bengkel',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0F172A),
                    side: const BorderSide(
                      color: Color(0xFFCBD5E1),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_rounded, size: 15),
                  label: const Text(
                    'WhatsApp SA',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
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
    );
  }

  // ── 7. Cost Summary ──────────────────────────────────────────────────────
  Widget _buildCostSummary() {
    final total = controller.totalPrice;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Rincian Biaya Sementara',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Text(
                  'Estimasi Transparan',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '(${controller.pitAssignments.length} Unit)',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              Text(
                total > 0 ? formatRupiah(total) : 'Tergantung servis',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined, size: 16),
              label: const Text(
                'Download Invoice Sementara (PDF)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primaryColor.shade100,
                foregroundColor: AppColors.primaryColor.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared Helpers ────────────────────────────────────────────────────────
  Widget _plateChip(String plate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFDFE3FC),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        plate,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF374151),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _statusBadge(String label, int stepIdx) {
    final Color bg;
    final Color fg;
    if (stepIdx < 0) {
      bg = const Color(0xFFE2E8F0);
      fg = const Color(0xFF64748B);
    } else if (stepIdx == 4) {
      bg = const Color(0xFFF0FDF4);
      fg = const Color(0xFF16A34A);
    } else if (stepIdx >= 2) {
      bg = const Color(0xFFFFFBEB);
      fg = const Color(0xFFD97706);
    } else {
      bg = const Color(0xFFEFF6FF);
      fg = const Color(0xFF2563EB);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
