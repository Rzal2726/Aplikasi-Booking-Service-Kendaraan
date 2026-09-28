import 'dart:ui' show PathMetric;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/services/formatter.dart';
import '../controllers/book_service_controller.dart';

class BookServiceView extends GetView<BookServiceController> {
  const BookServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final vehicles = controller.selectedVehicle;
      final services = controller.serviceList;
      final spareParts = controller.sparePartsList;
      final symptoms = controller.symptomsList;

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _buildInfoBanner(),
          const SizedBox(height: 16),
          ...List.generate(vehicles.length, (index) {
            final vehicle = vehicles[index];
            return _buildVehicleCard(
              context: context,
              vehicle: vehicle,
              index: index,
              services: services,
              spareParts: spareParts,
              symptoms: symptoms,
            );
          }),
          const SizedBox(height: 8),
          _buildAddMoreMotorButton(context),
          const SizedBox(height: 16),
          _buildWarrantyBadge(),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  // --- Top Info Banner ---
  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.info_outline, color: Color(0xFF0284C7), size: 18),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Pilih paket servis dan suku cadang untuk tiap motor secara mandiri. Kedua motor dapat dikerjakan secara bersamaan.",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF0F172A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Vehicle Card ---
  Widget _buildVehicleCard({
    required BuildContext context,
    required Map vehicle,
    required int index,
    required List services,
    required List spareParts,
    required List<String> symptoms,
  }) {
    final state = controller.getSelectionState(vehicle['id']);

    return Obx(() {
      final isExpanded = state.isExpanded.value;
      final subtotal = controller.getVehicleSubtotal(vehicle['id']);
      final summarySubtitle = controller.getVehicleSummarySubtitle(
        vehicle['id'],
      );
      final estimatedMinutes = controller.getVehicleEstimatedMinutes(
        vehicle['id'],
      );

      final formattedMileage = NumberFormat(
        '#,###',
        'id_ID',
      ).format(vehicle['odometer'] ?? 0);

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
            // Vehicle Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Motorcycle Thumbnail
                  Stack(
                    children: [
                      Container(
                        width: 68,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?auto=format&fit=crop&w=150&q=80',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            "#${index + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Vehicle Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1EB),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "MOTOR ${index + 1}",
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${vehicle['brand']} ${vehicle['model']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "${vehicle['number']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "•",
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "$formattedMileage km",
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand / Collapse Chevron Button
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => controller.toggleExpanded(vehicle['id']),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF475569),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (isExpanded) ...[
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Paket Servis Utama
                    _buildSectionHeader(
                      number: "1",
                      title: "PAKET SERVIS UTAMA",
                      trailing: const Text(
                        "Pilih salah satu",
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildServiceGrid(vehicle['id'], services, state),

                    const SizedBox(height: 20),
                    // Section 2: Suku Cadang & Oli Tambahan
                    _buildSectionHeader(
                      number: "2",
                      title: "SUKU CADANG & OLI TAMBAHAN",
                      
                    ),
                    const SizedBox(height: 12),
                    _buildSparePartsList(vehicle['id'], spareParts, state),

                    const SizedBox(height: 20),
                    // Section 3: Keluhan / Gejala Motor
                    _buildSectionHeader(
                      number: "3",
                      title: "KELUHAN / GEJALA MOTOR",
                    ),
                    const SizedBox(height: 12),
                    _buildSymptomsChips(vehicle['id'], symptoms, state),
                    const SizedBox(height: 12),
                    _buildNotesField(state),

                    const SizedBox(height: 16),
                    // Subtotal Motor Card
                    _buildSubtotalCard(
                      index: index,
                      subtitle: summarySubtitle,
                      price: subtotal,
                      minutes: estimatedMinutes,
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

  // --- Section Header Helper ---
  Widget _buildSectionHeader({
    required String number,
    required String title,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1EB),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  // --- Section 1: Service Packages Grid (2x2) ---
  Widget _buildServiceGrid(
    dynamic vehicleId,
    List services,
    MotorSelectionState state,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: services.length,
      itemBuilder: (context, idx) {
        final service = services[idx];
        return Obx(() {
          final isSelected = state.selectedServiceId.value == service['id'];

          return GestureDetector(
            onTap: () => controller.selectService(vehicleId, service['id']),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Service Icon Container
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getServiceIcon(service['icon'] ?? '', service['id']),
                          size: 18,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                      // Radio Button
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: const Color(0xFFCBD5E1),
                                  width: 1.5,
                                ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    service['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      height: 1.25,
                    ),
                  ),
                  const Spacer(),
                  const Divider(height: 8, color: Color(0xFFF1F5F9)),
                  Row(
                    children: [
                      const Text(
                        "Biaya: ",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formatRupiah(service['price'] ?? 0),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.primaryColor
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  IconData _getServiceIcon(String iconKey, int id) {
    switch (iconKey) {
      case 'settings':
        return Icons.settings_suggest_outlined;
      case 'oil':
        return Icons.water_drop_outlined;
      case 'cvt':
        return Icons.motion_photos_on_outlined;
      case 'tuneup':
        return Icons.speed_outlined;
      default:
        if (id == 1) return Icons.settings_suggest_outlined;
        if (id == 2) return Icons.water_drop_outlined;
        if (id == 3) return Icons.motion_photos_on_outlined;
        return Icons.speed_outlined;
    }
  }

  // --- Section 2: Spare Parts List with Checkboxes ---
  Widget _buildSparePartsList(
    dynamic vehicleId,
    List spareParts,
    MotorSelectionState state,
  ) {
    return Column(
      children: spareParts.map((part) {
        return Obx(() {
          final isChecked = state.selectedSparePartIds.contains(part['id']);

          return GestureDetector(
            onTap: () => controller.toggleSparePart(vehicleId, part['id']),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isChecked
                      ? AppColors.primaryColor.withOpacity(0.3)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Checkbox Square
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isChecked
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: isChecked
                          ? null
                          : Border.all(
                              color: const Color(0xFFCBD5E1),
                              width: 1.5,
                            ),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          part['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          part['description'] ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price
                  Text(
                    "+${formatRupiah(part['price'] ?? 0)}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  // --- Section 3: Symptoms Chips & Notes ---
  Widget _buildSymptomsChips(
    dynamic vehicleId,
    List<String> symptoms,
    MotorSelectionState state,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: symptoms.map((symptom) {
        return Obx(() {
          final isSelected = state.selectedSymptoms.contains(symptom);

          return GestureDetector(
            onTap: () => controller.toggleSymptom(vehicleId, symptom),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    size: 14,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    symptom,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF334155),
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildNotesField(MotorSelectionState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: state.notesController,
        maxLines: 2,
        style: const TextStyle(fontSize: 12.5, color: Color(0xFF1E293B)),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: "Tolong cek getaran CVT saat rpm rendah.",
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
        ),
      ),
    );
  }

  // --- Subtotal Card Inside Motor ---
  Widget _buildSubtotalCard({
    required int index,
    required String subtitle,
    required double price,
    required int minutes,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1EB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subtotal Motor ${index + 1}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatRupiah(price),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Estimasi ~$minutes Menit",
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Dashed Border Button to Add Another Motor ---
  Widget _buildAddMoreMotorButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddVehicleBottomSheet(context),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: const Color(0xFFCBD5E1),
          strokeWidth: 1.2,
          dashWidth: 6,
          dashSpace: 4,
          radius: 12,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: AppColors.primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "+ Tambah motor lainnya ke booking ini",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddVehicleBottomSheet(BuildContext context) {
    final allVehicles = controller.storageService.getVehicles();
    final remainingVehicles = allVehicles
        .where(
          (v) => !controller.selectedVehicle.any((sv) => sv['id'] == v['id']),
        )
        .toList();

    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Pilih Motor dari Garasi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              if (remainingVehicles.isEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      "Semua motor di garasi sudah ditambahkan ke booking ini.",
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ),
                ),
              ] else ...[
                ...remainingVehicles.map((v) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1EB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.two_wheeler,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    title: Text(
                      "${v['brand']} ${v['model']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      "${v['number']} • ${v['odometer']} km",
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(
                      Icons.add_circle,
                      color: AppColors.primaryColor,
                    ),
                    onTap: () {
                      Get.back();
                      controller.addVehicleToBooking(v);
                    },
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --- Guarantee Badge ---
  Widget _buildWarrantyBadge() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user_outlined,
          color: Color(0xFF10B981),
          size: 16,
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            "Garansi servis 7 hari atau 500 km di seluruh bengkel rekanan",
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
        ),
      ],
    );
  }
}

// --- Custom Dashed Border Painter for the button ---
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.dashWidth = 6,
    this.dashSpace = 4,
    this.radius = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        dashPath.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
