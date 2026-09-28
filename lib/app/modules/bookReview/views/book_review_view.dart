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

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. Top Banner: Konfirmasi Pesanan
          _buildTopBanner(motorCount),
          const SizedBox(height: 16),

          // 2. Workshop & Schedule Summary Card
          _buildWorkshopScheduleCard(scheduleController, bookScreenController),
          const SizedBox(height: 16),

          // 3. Simultan Dark Banner
          _buildSimultanBanner(),
          const SizedBox(height: 16),

          // 4. Motor 1 Card (Honda Vario 160 CBS)
          _buildMotor1Card(bookScreenController),
          const SizedBox(height: 16),

          // 5. Motor 2 Card (Yamaha NMAX 155 Connected)
          _buildMotor2Card(bookScreenController),
          const SizedBox(height: 16),

          // 6. Informasi Pemesan & Kedatangan
          _buildCustomerInfoCard(),
          const SizedBox(height: 16),

          // 7. Rincian Pembayaran
          _buildPaymentSummaryCard(),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  // --- 1. Top Banner ---
  Widget _buildTopBanner(int motorCount) {
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
                  "Pemeriksaan $motorCount motor",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, size: 13, color: Color(0xFF16A34A)),
                SizedBox(width: 3),
                Text(
                  "2 Pit Siap Simultan",
                  style: TextStyle(
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
  ) {
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
                const Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Sabtu, 24 Feb 2024 • 09:30 WIB",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 12,
                            color: Color(0xFF16A34A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Pengerjaan Paralel (2 Pit Sekaligus)",
                            style: TextStyle(
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
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. Simultan Dark Banner ---
  Widget _buildSimultanBanner() {
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Simultan: Pit 03 & Pit 04",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "09:30 - 10:30 WIB (~60 mnt selesai)",
                  style: TextStyle(
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

  // --- 4. Motor 1 Card (Honda Vario 160 CBS) ---
  Widget _buildMotor1Card(BookScreenController bookScreenController) {
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
          // Header: Motor 1
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Motor 1",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Honda Vario 160 CBS",
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      "B 1234 XYZ",
                      style: TextStyle(
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
            child: const Row(
              children: [
                Icon(
                  Icons.engineering_outlined,
                  size: 15,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 6),
                Text(
                  "Pit 03 • Mekanik: Bpk. Dadang",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
                Spacer(),
                Row(
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
          // Service Items
          _buildReviewItem(
            title: "Servis Berkala Lengkap",
            subtitle: "Pembersihan throttle body & CVT (~45 mnt)",
            price: 105000,
          ),
          const SizedBox(height: 10),
          _buildReviewItem(
            title: "Oli Mesin AHM MPX2 0.8L",
            subtitle: "Suku Cadang Asli OEM Honda",
            price: 54000,
          ),
          const SizedBox(height: 10),
          _buildReviewItem(
            title: "Busi Honda CPR9EA-9",
            subtitle: "Penggantian Busi Standar Pabrikan",
            price: 26000,
          ),
          const SizedBox(height: 12),
          // Notes Box
          _buildOwnerNote(
            "Tarikan gas berat, getaran CVT rpm rendah saat akselerasi.",
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal Motor 1 (~60 Menit)",
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              Text(
                "Rp 185.000",
                style: TextStyle(
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
  }

  // --- 5. Motor 2 Card (Yamaha NMAX 155 Connected) ---
  Widget _buildMotor2Card(BookScreenController bookScreenController) {
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
          // Header: Motor 2
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Motor 2",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Yamaha NMAX 155 Connected",
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      "D 5678 ABC",
                      style: TextStyle(
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
            child: const Row(
              children: [
                Icon(
                  Icons.engineering_outlined,
                  size: 15,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 6),
                Text(
                  "Pit 04 • Mekanik: Bpk. Ilham",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
                Spacer(),
                Row(
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
          // Service Items
          _buildReviewItem(
            title: "Ganti Oli Mesin & Gardan Yamalube",
            subtitle: "Paket Super Matic 1.0L + Gardan Oil (~15 mnt)",
            price: 85000,
          ),
          const SizedBox(height: 10),
          _buildReviewItem(
            title: "Kampas Rem Belakang (Brake Pad)",
            subtitle: "OEM Yamaha Genuine Parts (~30 mnt)",
            price: 95000,
          ),
          const SizedBox(height: 12),
          // Notes Box
          _buildOwnerNote(
            "Rem belakang bunyi berdecit keras saat kondisi macet stop-and-go.",
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal Motor 2 (~60 Menit)",
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              Text(
                "Rp 180.000",
                style: TextStyle(
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
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
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

  // --- 6. Informasi Pemesan & Kedatangan ---
  Widget _buildCustomerInfoCard() {
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
              Icon(
                Icons.assignment_ind_outlined,
                size: 18,
                color: Color(0xFF475569),
              ),
              SizedBox(width: 8),
              Text(
                "Informasi Pemesan & Kedatangan",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Spacer(),
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

  // --- 7. Rincian Pembayaran ---
  Widget _buildPaymentSummaryCard() {
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
              Icon(
                Icons.receipt_outlined,
                size: 18,
                color: Color(0xFF475569),
              ),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Biaya Servis & Part (2 Motor)",
                style: TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
              ),
              Text(
                "Rp 365.000",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Diskon Multi-Motor (Paket 2 Pit)",
                style: TextStyle(fontSize: 12.5, color: Color(0xFF16A34A)),
              ),
              Text(
                "-Rp 35.000",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Tagihan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Estimasi pengerjaan ~60 menit",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Text(
                formatRupiah(controller.totalPayment),
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
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
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
