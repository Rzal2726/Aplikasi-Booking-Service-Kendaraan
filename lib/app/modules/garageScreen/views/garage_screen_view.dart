import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:project/app/components/AppIcon.dart';
import 'package:project/app/components/buttons/buttonPrimary.dart';
import 'package:project/app/components/cards/cardBasic.dart';
import 'package:project/app/components/cards/emptyCard.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/routes/app_pages.dart';
import 'package:project/app/services/formatter.dart';

import '../controllers/garage_screen_controller.dart';

class GarageScreenView extends GetView<GarageScreenController> {
  const GarageScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.initGarage();
      },
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          myGarageCard(),
          SizedBox(height: 16),
          Obx(() {
            final vehicleList = controller.vehicleList;
            if (controller.loadingMap['getVehicle'] == true) {
              return Center(child: CircularProgressIndicator());
            }
            if (vehicleList.isEmpty) {
              return EmptyCard(
                message: "Tidak ada kendaraan yang terdaftar",
                actionButton: ButtonPrimary(
                  onPressed: () {},
                  text: "Tambahkan Kendaraan",
                  icon: Icon(Icons.add_circle_outline, color: Colors.white),
                ),
              );
            }
            return Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daftar Motor (${vehicleList.length})",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vehicleList.length,
                  itemBuilder: (context, index) {
                    final vehicle = Map<String, dynamic>.from(
                      vehicleList[index] as Map,
                    );
                    return vehicleCard(vehicle: vehicle);
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget myGarageCard() {
    return BasicCard(
      content: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.warehouse_outlined,
                  color: AppColors.primaryColor,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Garasi Saya",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Tidak Ada Motor Terdaftar",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ButtonPrimary(
              onPressed: () {
                Get.bottomSheet(
                  addVehicleBottomSheet(),
                  isScrollControlled: true,
                );
              },
              text: "Tambah Motor Baru",
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
            ),
          ),
          // Text(controller.vehicleList.toString()),
        ],
      ),
    );
  }

  Widget vehicleCard({required Map<String, dynamic> vehicle}) {
    final number = vehicle['number'] ?? "";
    final brand = vehicle['brand'] ?? "";
    final model = vehicle['model'] ?? "";
    final year = vehicle['year']?.toString() ?? "";
    final num odo = num.tryParse(vehicle['odometer']?.toString() ?? '0') ?? 0;
    final isMain = vehicle['isMain'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: BasicCard(
        content: Column(
          children: [
            Row(
              spacing: 16,
              children: [
                AppIcon(size: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              number,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (isMain) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFF86EFAC),
                                ),
                              ),
                              child: const Text(
                                "Utama",
                                style: TextStyle(
                                  color: Color(0xFF16A34A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$brand $model",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Tahun $year • ${NumberFormat('#,###', 'id_ID').format(odo)} KM",
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
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ButtonPrimary(
                    onPressed: () {
                      Get.toNamed(
                        Routes.BOOK_SCREEN,
                        arguments: {
                          'vehicle': vehicle,
                          'vehicleId': vehicle['id'],
                          'fromGarage': true,
                        },
                      );
                    },
                    text: "Booking Servis",
                    icon: const Icon(Icons.build_rounded, size: 16),
                  ),
                ),
                ButtonPrimary(
                  color: Colors.grey.shade100,
                  onPressed: () {
                    Get.bottomSheet(
                      vehicleDetailBottomSheet(vehicle),
                      isScrollControlled: true,
                    );
                  },
                  text: "Detail",
                  textColor: Colors.black,
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Vehicle Detail BottomSheet ──────────────────────────────────────────
  Widget vehicleDetailBottomSheet(Map<String, dynamic> vehicle) {
    final brand = vehicle['brand'] ?? '—';
    final model = vehicle['model'] ?? '—';
    final number = vehicle['number'] ?? '—';
    final year = vehicle['year']?.toString() ?? '—';
    final num odo = num.tryParse(vehicle['odometer']?.toString() ?? '0') ?? 0;
    final isMain = vehicle['isMain'] == true;

    // Maintenance calculations based on 4,000 KM service interval
    final nextServiceKm = ((odo / 4000).floor() + 1) * 4000;
    final kmRemaining = nextServiceKm - odo;
    final progressToNext = ((odo % 4000) / 4000.0).clamp(0.0, 1.0);

    // OEM Spare parts and Symptoms from system JSON
    final spareParts = controller.getSpareParts();
    final symptoms = controller.getSymptoms();

    // Service History for this specific vehicle
    final activities = controller.getVehicleActivities(vehicle['id'], number);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(Get.context!).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle & Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.two_wheeler_rounded,
                          color: AppColors.primaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Detail Kendaraan",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              "Spesifikasi & Riwayat Perawatan",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (Get.isBottomSheetOpen == true) Get.back();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                children: [
                  // 1. Vehicle Hero Card
                  _buildVehicleHeroCard(
                    brand: brand,
                    model: model,
                    number: number,
                    year: year,
                    odometer: odo,
                    isMain: isMain,
                  ),
                  const SizedBox(height: 16),

                  // 2. Status & Rekomendasi Servis Berkala
                  _buildServiceIntervalCard(
                    odo: odo,
                    nextServiceKm: nextServiceKm,
                    kmRemaining: kmRemaining,
                    progress: progressToNext,
                  ),
                  const SizedBox(height: 16),

                  // 3. Suku Cadang Rekomendasi Pabrikan (OEM Data)
                  // if (spareParts.isNotEmpty) ...[
                  //   _buildSparePartsSection(spareParts),
                  //   const SizedBox(height: 16),
                  // ],

                  // 4. Gejala Yang Perlu Diperhatikan (Data Gejala)
                  if (symptoms.isNotEmpty) ...[
                    _buildSymptomsSection(symptoms),
                    const SizedBox(height: 16),
                  ],

                  // 5. Riwayat Servis Motor Ini
                  _buildVehicleHistorySection(activities),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Bottom Actions Area
            _buildBottomActionButtons(vehicle, isMain),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleHeroCard({
    required String brand,
    required String model,
    required String number,
    required String year,
    required num odometer,
    required bool isMain,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Indonesian License Plate Style
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const Spacer(),
              if (isMain)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Color(0xFF16A34A),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Motor Utama",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: const Text(
                    "Motor Terdaftar",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "$brand $model",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          // 3 stat tiles
          Row(
            children: [
              Expanded(
                child: _buildHeroStatTile(
                  icon: Icons.calendar_today_outlined,
                  label: "Tahun",
                  value: year,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildHeroStatTile(
                  icon: Icons.speed_outlined,
                  label: "Odometer",
                  value:
                      "${NumberFormat('#,###', 'id_ID').format(odometer)} KM",
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildHeroStatTile(
                  icon: Icons.verified_outlined,
                  label: "Merk Pabrikan",
                  value: brand,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIntervalCard({
    required num odo,
    required num nextServiceKm,
    required num kmRemaining,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.alarm_on_rounded,
                  color: Color(0xFF16A34A),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Status Perawatan & Jadwal Servis",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF166534),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Servis Berikutnya: ${NumberFormat('#,###', 'id_ID').format(nextServiceKm)} KM",
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                kmRemaining > 0
                    ? "Sisa ~${NumberFormat('#,###', 'id_ID').format(kmRemaining)} KM"
                    : "Waktunya Servis!",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: kmRemaining > 0
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              color: const Color(0xFF16A34A),
              backgroundColor: const Color(0xFFDCFCE7),
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Anjuran Pabrikan: Servis berkala dan ganti oli disarankan tiap 4.000 KM atau 3 bulan agar kondisi mesin dan transmisi tetap prima.",
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF374151),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparePartsSection(List<Map<String, dynamic>> spareParts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.settings_suggest_outlined,
              size: 16,
              color: AppColors.primaryColor,
            ),
            SizedBox(width: 6),
            Text(
              "Suku Cadang Rekomendasi (OEM)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          "Komponen orisinal pabrikan sesuai spesifikasi mesin",
          style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 10),
        ...spareParts.map((part) {
          final isOem = part['isOem'] == true;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.build_circle_outlined,
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
                          Expanded(
                            child: Text(
                              part['name'] ?? '—',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          if (isOem) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "OEM",
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ),
                          ],
                        ],
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
                const SizedBox(width: 8),
                Text(
                  formatRupiah((part['price'] as num?) ?? 0),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSymptomsSection(List<String> symptoms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.report_problem_outlined,
              size: 16,
              color: Color(0xFFD97706),
            ),
            SizedBox(width: 6),
            Text(
              "Gejala Yang Perlu Diperhatikan",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          "Jika motor mengalami hal berikut, disarankan segera servis",
          style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: symptoms.map((sym) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, size: 5, color: Color(0xFFD97706)),
                  const SizedBox(width: 6),
                  Text(
                    sym,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVehicleHistorySection(List<Map<String, dynamic>> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.history_rounded,
              size: 16,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 6),
            const Text(
              "Riwayat Servis Motor Ini",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const Spacer(),
            if (activities.isNotEmpty)
              Text(
                "${activities.length} Sesi",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (activities.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.history_toggle_off_rounded,
                  size: 20,
                  color: Color(0xFF94A3B8),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Belum ada riwayat servis. Pesan servis pertama Anda sekarang!",
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          )
        else
          ...activities.map((act) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        act['workshop'] ?? 'Bengkel Resmi',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "#${act['code'] ?? ''}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
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
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        act['scheduleDate'] ?? (act['date'] ?? '—'),
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.payments_outlined,
                        size: 12,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatRupiah((act['totalPrice'] as num?) ?? 0),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildBottomActionButtons(Map<String, dynamic> vehicle, bool isMain) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ButtonPrimary(
              onPressed: () {
                if (Get.isBottomSheetOpen == true) Get.back();
                Get.toNamed(
                  Routes.BOOK_SCREEN,
                  arguments: {
                    'vehicle': vehicle,
                    'vehicleId': vehicle['id'],
                    'fromGarage': true,
                  },
                );
              },
              text: "Booking Servis Motor Ini",
              icon: const Icon(
                Icons.build_circle_outlined,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (!isMain) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      controller.setMainVehicle(vehicle['id']);
                    },
                    icon: const Icon(
                      Icons.star_outline_rounded,
                      size: 16,
                      color: Color(0xFF16A34A),
                    ),
                    label: const Text(
                      "Jadikan Utama",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF86EFAC)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text("Hapus Motor"),
                        content: Text(
                          "Hapus ${vehicle['brand']} ${vehicle['model']} (${vehicle['number']}) dari garasi?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Get.back(); // close dialog
                              controller.deleteVehicle(vehicle['id']);
                            },
                            child: const Text("Hapus"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Color(0xFFDC2626),
                  ),
                  label: const Text(
                    "Hapus Motor",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addVehicleBottomSheet() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            Row(
              spacing: 8,
              children: [
                Icon(
                  Icons.two_wheeler,
                  size: 24,
                  color: AppColors.primaryColor,
                ),
                Expanded(
                  child: Text(
                    "Tambahkan Motor ke Garasi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (Get.isBottomSheetOpen == true) {
                      Get.back();
                    }
                  },
                  child: Icon(Icons.close, size: 24),
                ),
              ],
            ),
            Text(
              "Lengkapi rincian motor untuk pantauan otomatis jadwal servis, reminder oli, dan rekam riwayat servis.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              textAlign: TextAlign.start,
              "Merk Pabrikan",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            Obx(() {
              return SizedBox(
                height: 32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.brandList.length,
                  itemBuilder: (context, index) {
                    final brand = controller.brandList[index];
                    return Obx(
                      () => brandOptionButton(
                        onTap: () {
                          controller.selectedBrand.value = brand['brand'];
                        },
                        selected:
                            controller.selectedBrand.value == brand['brand'],
                        brand: brand['brand'],
                      ),
                    );
                  },
                ),
              );
            }),
            Text(
              textAlign: TextAlign.start,
              "Model Motor",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            Obx(() {
              final filtered = controller.filteredModelList;
              return modelDropdown(filtered);
            }),
            Text(
              textAlign: TextAlign.start,
              "Nomor Plat Polisi",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            platField(),
            yearAndOdometer(),
            SizedBox(
              width: double.infinity,
              child: ButtonPrimary(
                onPressed: () {
                  controller.saveVehicle();
                },
                text: "Simpan Motor Ke Garasi",
                icon: Icon(Icons.save, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget brandOptionButton({
    required Function() onTap,
    required bool selected,
    required String brand,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor.withAlpha(25)
              : AppColors.backgroundSwatch,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          brand,
          style: TextStyle(
            color: selected ? AppColors.primaryColor : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget modelDropdown(List<Map<String, dynamic>> entries) {
    return DropdownMenu<String>(
      key: ValueKey(controller.selectedBrand.value),
      width: double.infinity,
      menuHeight: 250, // Limits dropdown list height with smooth scrolling
      hintText: "Pilih Model",
      requestFocusOnTap: false, // Prevents keyboard pop-up if non-editable
      // Custom Icons
      trailingIcon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey,
      ),
      selectedTrailingIcon: Icon(
        Icons.keyboard_arrow_up_rounded,
        color: AppColors.primaryColor,
      ),

      // Text & Input Formatting
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),

      // Outer Input Field Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            AppColors.backgroundSwatch, // Matching subtle input background
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        // Default / Unfocused Border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        // Active / Focused Border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.normal,
        ),
      ),

      // Dropdown Popup Menu Styling
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(6),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 8),
        ),
      ),

      // Menu Item Entries
      onSelected: (String? value) {
        if (value != null) {
          controller.selectedModel.value = value;
        }
      },
      dropdownMenuEntries: entries.map((data) {
        final String modelName = data['model'];
        return DropdownMenuEntry<String>(
          value: modelName,
          label: modelName,
          style: MenuItemButton.styleFrom(
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  InputDecoration decoration(String hint, {TextStyle? hintStyle}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.backgroundSwatch,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(16),
      ),
      hintText: hint,
      hintStyle: hintStyle,
    );
  }

  Widget platField() {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          flex: 1,
          child: TextField(
            controller: controller.platNumRegion,
            decoration: decoration(
              "B",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller.platNumRegist,
            decoration: decoration(
              "1234",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: controller.platNumSubRegion,
            decoration: decoration(
              "XYZ",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget yearAndOdometer() {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.start,
                "Tahun Pembuatan",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              TextField(
                onChanged: (value) {
                  controller.productionYear.value = value.trim();
                },
                decoration: decoration(
                  "2020",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.start,
                "Odometer (KM)",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              TextField(
                onChanged: (value) {
                  controller.odometer.value = value.trim();
                },
                decoration: decoration(
                  "Contoh: 12500",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
