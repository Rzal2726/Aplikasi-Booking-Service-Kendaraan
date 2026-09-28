import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/components/AppIcon.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/routes/app_pages.dart';
import 'package:project/app/services/formatter.dart';
import '../controllers/book_confirm_controller.dart';

class BookConfirmView extends GetView<BookConfirmController> {
  const BookConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offAllNamed(Routes.HOME_SCREEN);
        }
      },
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(),
              SizedBox(width: 8),
              const Text(
                'Status Booking',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: Obx(() {
          final act = controller.activity.value;
          if (act == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          final vehicleActivities = controller.vehicleActivities;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // 1. Success Header
                _buildSuccessHeader(),
                const SizedBox(height: 20),

                // 2. Workshop & Schedule Card
                _buildWorkshopCard(),
                const SizedBox(height: 12),

                // // 3. Direction + Contact Buttons
                // _buildActionButtons(),
                // const SizedBox(height: 20),

                // 4. Vehicle List Header
                _buildVehicleListHeader(vehicleActivities.length),
                const SizedBox(height: 10),

                // 5. Vehicle Cards
                ...List.generate(vehicleActivities.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildVehicleCard(vehicleActivities[i], i),
                  );
                }),

                const SizedBox(height: 8),

                // 6. Total Payment
                _buildTotalPayment(),
                const SizedBox(height: 24),

                // 7. Bottom Buttons
                _buildTrackingButton(),
                const SizedBox(height: 10),
                _buildHomeButton(),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  // --- 1. Success Header ---
  Widget _buildSuccessHeader() {
    return Column(
      children: [
        // Big green check circle
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF16A34A),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF16A34A).withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 38),
        ),
        const SizedBox(height: 14),

        // "Reservasi Aktif" badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF86EFAC)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 7, color: Color(0xFF16A34A)),
              SizedBox(width: 5),
              Text(
                'Reservasi Aktif',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        const Text(
          'Booking Berhasil Dikonfirmasi!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 14),

        // Booking code box
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: Column(
              children: [
                const Text(
                  'KODE BOOKING',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#${controller.bookingCode}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: controller.copyBookingCode,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        const Text(
          'Silakan datang 10 menit sebelum jadwal.\nTunjukkan kode booking ini ke Service Advisor di\npintu masuk pit.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            color: Color(0xFF64748B),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // --- 2. Workshop & Schedule Card ---
  Widget _buildWorkshopCard() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.workshopName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Resmi',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.scheduleDate} \u2022 ${controller.time}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.precision_manufacturing_outlined,
                        size: 12,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Obx(() {
                        final act = controller.activity.value;
                        final assignments = act?['pitAssignments'] as List?;
                        final pitText =
                            assignments != null && assignments.isNotEmpty
                            ? assignments
                                  .map((a) => (a as Map)['pit'] ?? '')
                                  .join(' & ')
                            : '—';
                        return Text(
                          'Pit Servis: $pitText (Sedang disiapkan)',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. Action Buttons ---
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
            ),
            icon: const Icon(
              Icons.directions_outlined,
              color: Color(0xFF475569),
              size: 18,
            ),
            label: const Text(
              'Petunjuk Arah',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
            ),
            icon: const Icon(
              Icons.phone_outlined,
              color: Color(0xFF475569),
              size: 18,
            ),
            label: const Text(
              'Hubungi Bengkel',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- 4. Vehicle List Header ---
  Widget _buildVehicleListHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Rincian Kendaraan ($count Motor)',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Antrean Terjadwal',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }

  // --- 5. Vehicle Card ---
  Widget _buildVehicleCard(Map<String, dynamic> vehicleActivity, int index) {
    final vehicleId = vehicleActivity['vehicleID'];
    final vehicle = controller.getVehicle(vehicleId);
    final serviceIds = List<dynamic>.from(vehicleActivity['serviceIds'] ?? []);

    final vehicleName = vehicle != null
        ? '${vehicle['brand']} ${vehicle['model']}'
        : 'Kendaraan #$vehicleId';
    final plateNumber = vehicle?['number'] ?? '—';

    final pitAssignments =
        controller.activity.value?['pitAssignments'] as List? ?? [];
    final pitInfo = index < pitAssignments.length
        ? Map<String, dynamic>.from(pitAssignments[index] as Map)
        : <String, dynamic>{};
    final pitLabel = pitInfo['pit'] ?? 'Pit 0${index + 3}';
    final mechanic = pitInfo['mechanic'] ?? '—';

    final packageLabel = controller.buildPackageLabel(serviceIds);
    final packagePrice = _calcPackagePrice(serviceIds);

    return Container(
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
      child: Column(
        children: [
          // Vehicle header row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                // Motorbike icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.two_wheeler,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              vehicleName,
                              style: const TextStyle(
                                fontSize: 13.5,
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
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: Text(
                              plateNumber,
                              style: const TextStyle(
                                fontSize: 10,
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
                        '$pitLabel \u2022 Mekanik: $mechanic',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 6, color: Color(0xFF64748B)),
                      SizedBox(width: 4),
                      Text(
                        'Menunggu',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),

          // Package info row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paket Layanan',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        packageLabel,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatRupiah(packagePrice),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calcPackagePrice(List<dynamic> serviceIds) {
    double total = 0;
    final services = controller.storageService.getServices();
    final parts = controller.storageService.getSpareParts();
    for (final sid in serviceIds) {
      final svc = services.firstWhereOrNull((s) => s['id'] == sid);
      if (svc != null) {
        total += (svc['price'] as num).toDouble();
      } else {
        final part = parts.firstWhereOrNull((p) => p['id'] == sid);
        if (part != null) {
          total += (part['price'] as num).toDouble();
        }
      }
    }
    return total;
  }

  // --- 6. Total Payment ---
  Widget _buildTotalPayment() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Bayar di Bengkel',
                  style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
                ),
                Text(
                  formatRupiah(controller.totalPrice),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
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
                      'Pembayaran aman di kasir: Tunai, QRIS, & Kartu Debit',
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
      ),
    );
  }

  // --- 7. Tracking Button ---
  Widget _buildTrackingButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.goTracking,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.track_changes_rounded, size: 20),
        label: const Text(
          'Pantau Status Servis (Live Tracking) \u2192',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- 8. Home Button ---
  Widget _buildHomeButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: controller.goHome,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.white,
        ),
        child: const Text(
          'Kembali ke Beranda',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF334155),
          ),
        ),
      ),
    );
  }
}
