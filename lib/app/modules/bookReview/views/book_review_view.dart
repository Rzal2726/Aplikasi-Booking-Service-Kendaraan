import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/modules/bookSchedule/controllers/book_schedule_controller.dart';
import 'package:project/app/modules/bookScreen/controllers/book_screen_controller.dart';
import 'package:project/app/modules/bookService/controllers/book_service_controller.dart';
import 'package:project/app/services/formatter.dart';
import '../controllers/book_review_controller.dart';

class BookReviewView extends GetView<BookReviewController> {
  const BookReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.find<BookScheduleController>();
    final serviceController = Get.find<BookServiceController>();
    final bookScreenController = Get.find<BookScreenController>();

    return Obx(() {
      final vehicles = serviceController.selectedVehicle;
      final motorCount = vehicles.length;
      final isParallel =
          scheduleController.workMethod.value == 'parallel' && motorCount >= 2;

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. Top Banner: Konfirmasi Pesanan
          _buildTopBanner(motorCount, isParallel),
          const SizedBox(height: 16),

          // 2. Workshop & Schedule Summary Card
          _buildWorkshopScheduleCard(
            scheduleController,
            bookScreenController,
            isParallel,
            motorCount,
          ),
          const SizedBox(height: 16),

          // 3. Simultan Dark Banner (Only for 2 or more motors)
          if (motorCount >= 2) ...[
            _buildSimultanBanner(scheduleController, isParallel),
            const SizedBox(height: 16),
          ],

          // 4. Dynamic Motor Cards
          ...List.generate(vehicles.length, (index) {
            final vehicle = vehicles[index];
            return Column(
              children: [
                _buildMotorCard(
                  index: index,
                  vehicle: vehicle,
                  serviceController: serviceController,
                  bookScreenController: bookScreenController,
                ),
                if (index < vehicles.length - 1) const SizedBox(height: 16),
              ],
            );
          }),

          const SizedBox(height: 16),

          // 5. Informasi Pemesan & Kedatangan
          _buildCustomerInfoCard(scheduleController),
          const SizedBox(height: 16),

          // 6. Rincian Pembayaran
          _buildPaymentSummaryCard(serviceController, scheduleController),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  // --- 1. Top Banner ---
  Widget _buildTopBanner(int motorCount, bool isParallel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                "4",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Konfirmasi Pesanan",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  motorCount > 1
                      ? "Pemeriksaan $motorCount motor"
                      : "Pemeriksaan 1 motor",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          if (isParallel)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt, size: 13, color: Color(0xFF16A34A)),
                  const SizedBox(width: 3),
                  Text(
                    "$motorCount Pit Siap Simultan",
                    style: const TextStyle(
                      color: Color(0xFF16A34A),
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- 2. Workshop & Schedule Card ---
  Widget _buildWorkshopScheduleCard(
    BookScheduleController scheduleController,
    BookScreenController bookScreenController,
    bool isParallel,
    int motorCount,
  ) {
    final selectedDate = scheduleController
        .availableDates[scheduleController.selectedDateIndex.value];
    final dateStr =
        "${selectedDate['day']}, ${selectedDate['date']} ${scheduleController.selectedMonthYear.value}";
    final timeStr = "${scheduleController.selectedTimeSlot.value} WIB";

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
          // Workshop Header with "Ubah"
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
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
                      scheduleController.workshopName.value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scheduleController.workshopAddress.value,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  bookScreenController.pageIndex.value = 2; // Jump to Jadwal
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 13,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 3),
                    Text(
                      "Ubah",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Schedule Details Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$dateStr \u2022 $timeStr",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                if (isParallel) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 12,
                              color: Color(0xFF16A34A),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Pengerjaan Paralel ($motorCount Pit Sekaligus)",
                              style: const TextStyle(
                                color: Color(0xFF16A34A),
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. Simultan Dark Banner ---
  Widget _buildSimultanBanner(
    BookScheduleController scheduleController,
    bool isParallel,
  ) {
    final assignments = scheduleController.pitAssignments;
    final pitLabels = assignments.map((a) => a['pit'] ?? '').toList();
    final pitText = pitLabels.isNotEmpty ? pitLabels.join(' & ') : '\u2014';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.alt_route_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isParallel ? "Simultan: $pitText" : "Berurutan: $pitText",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  scheduleController.estimatedEndTimeText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B).withOpacity(0.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 6, color: Color(0xFF34D399)),
                SizedBox(width: 4),
                Text(
                  "Standby",
                  style: TextStyle(
                    color: Color(0xFF34D399),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. Dynamic Motor Card ---
  Widget _buildMotorCard({
    required int index,
    required dynamic vehicle,
    required BookServiceController serviceController,
    required BookScreenController bookScreenController,
  }) {
    final vehicleId = vehicle['id'];
    final motorLabel = "Motor ${index + 1}";
    final vehicleName = "${vehicle['brand']} ${vehicle['model']}";
    final plateNumber = vehicle['number'] ?? "\u2014";
    final state = serviceController.getSelectionState(vehicleId);

    return Obx(() {
      final selectedService = serviceController.getSelectedServiceData(
        vehicleId,
      );
      final selectedParts = serviceController.getSelectedSparePartsData(
        vehicleId,
      );
      final notes = state.notesController.text;
      final subtotal = serviceController.getVehicleSubtotal(vehicleId);
      final durationMinutes = serviceController.getVehicleEstimatedMinutes(
        vehicleId,
      );

      // Find pit assignment for this vehicle
      final pitAssignments = Get.find<BookScheduleController>().pitAssignments;
      final pitInfo = pitAssignments.length > index
          ? pitAssignments[index]
          : null;
      final pitLabel = pitInfo?['pit'] ?? "\u2014";
      final mechanic = pitInfo?['mechanic'] ?? "\u2014";

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
            // Header: Motor N
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    motorLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicleName,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        plateNumber,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    bookScreenController.pageIndex.value = 1; // Back to Service
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 13,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 3),
                      Text(
                        "Ubah",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Mechanic sub-bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.engineering_outlined,
                    size: 15,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "$pitLabel \u2022 Mekanik: $mechanic",
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const Spacer(),
                  const Row(
                    children: [
                      Icon(Icons.circle, size: 6, color: Color(0xFF16A34A)),
                      SizedBox(width: 3),
                      Text(
                        "Standby",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Selected Service
            if (selectedService != null) ...[
              _buildReviewItem(
                title: selectedService['name'] ?? "\u2014",
                subtitle: selectedService['description'] ?? "",
                price: (selectedService['price'] as num).toDouble(),
              ),
              const SizedBox(height: 10),
            ],
            // Selected Spare Parts
            ...selectedParts.map(
              (part) => Column(
                children: [
                  _buildReviewItem(
                    title: part['name'] ?? "\u2014",
                    subtitle: part['description'] ?? "",
                    price: (part['price'] as num).toDouble(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Owner Notes (if any)
            if (notes.isNotEmpty) ...[
              _buildOwnerNote(notes),
              const SizedBox(height: 12),
            ],
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtotal $motorLabel (~$durationMinutes Menit)",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  formatRupiah(subtotal),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildReviewItem({
    required String title,
    required String subtitle,
    required double price,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        Text(
          formatRupiah(price),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerNote(String note) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 15,
            color: Color(0xFFD97706),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Catatan Pemilik:",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "\"$note\"",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF78350F),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. Informasi Pemesan & Kedatangan ---
  Widget _buildCustomerInfoCard(BookScheduleController scheduleController) {
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
                Icons.assignment_ind_outlined,
                size: 18,
                color: Color(0xFF475569),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const Text(
                  "Informasi Pemesan & Kedatangan",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // User row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                Text(
                  controller.customerName.value,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                Text(
                  controller.customerPhone.value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Arrival row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: Color(0xFF16A34A),
                ),
                const SizedBox(width: 8),
                Text(
                  controller.arrivalMethod.value,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    controller.arrivalTime.value,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Warranty row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 16,
                  color: Color(0xFF16A34A),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Garansi servis resmi 7 hari atau 500 km pemakaian",
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF15803D),
                      fontWeight: FontWeight.w500,
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

  // --- 6. Rincian Pembayaran ---
  Widget _buildPaymentSummaryCard(
    BookServiceController serviceController,
    BookScheduleController scheduleController,
  ) {
    final subtotal = serviceController.totalPrice;
    final motorCount = serviceController.selectedVehicle.length;
    final discount = controller.discountAmount;
    final total = controller.totalPayment;
    final estimatedMinutes = serviceController.totalEstimatedMinutes;

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
              Icon(Icons.receipt_outlined, size: 18, color: Color(0xFF475569)),
              SizedBox(width: 8),
              Text(
                "Rincian Pembayaran",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Biaya Servis & Part ($motorCount Motor)",
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF475569),
                ),
              ),
              Text(
                formatRupiah(subtotal),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          if (discount > 0) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Diskon Multi-Motor (Paket 2 Pit)",
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF16A34A)),
                ),
                Text(
                  "-${formatRupiah(discount)}",
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Biaya Reservasi & Administrasi",
                style: TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
              ),
              Text(
                "GRATIS",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Tagihan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Estimasi pengerjaan ~$estimatedMinutes menit",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Text(
                formatRupiah(total),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Info box at bottom
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: Color(0xFF64748B)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Bayar di Bengkel: Tunai, QRIS, atau Kartu setelah servis selesai dan kedua motor lolos uji final inspection.",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      height: 1.35,
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
}
