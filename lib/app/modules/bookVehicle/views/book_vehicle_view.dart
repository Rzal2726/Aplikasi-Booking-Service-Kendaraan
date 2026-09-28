import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:project/app/components/buttons/buttonPrimary.dart';
import 'package:project/app/const/appcolors.dart';

import '../controllers/book_vehicle_controller.dart';

class BookVehicleView extends GetView<BookVehicleController> {
  const BookVehicleView({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      physics: NeverScrollableScrollPhysics(),
      children: [
        infoCard(),
        SizedBox(height: 16),
        Obx(() {
          final _ = controller.selectedVehicle.length;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.vehicleList.length,
            itemBuilder: (context, index) {
              final data = controller.vehicleList[index];
              return VehicleSelectionCard(
                title: "${data['brand']} ${data['model']}",
                year: data['year'].toString(),
                licensePlate: data['number'],
                mileageText: data['odometer'].toString(),
                isSelected: controller.isSelected(data),
                onTap: () {
                  controller.selectVehicle(data);
                },
              );
            },
          );
        }),
        ButtonPrimary(
          color: AppColors.backgroundSwatch.shade200,
          textColor: AppColors.primaryColor,
          onPressed: () {
            Get.bottomSheet(addVehicleBottomSheet(), isScrollControlled: true);
          },
          text: "Tambah Motor Baru",
          icon: Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
        ),
      ],
    );
  }

  Widget infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF3FF), // Light blue tone
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.two_wheeler, color: Colors.deepOrange),
          ),
          const SizedBox(width: 12),
          // Info Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Servis Sekaligus',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green, // Green badge accent
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Hemat Waktu',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Hemat waktu dengan servis hingga 3 motor sekaligus dalam 1 kunjungan bengkel.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
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

enum VehicleStatus { waktunyaServis, gantiOli, kondisiPrima }

class VehicleSelectionCard extends StatelessWidget {
  final String title;
  final String year;
  final String licensePlate;
  final String mileageText;
  // final String imageUrl;
  final bool isSelected;
  // final VehicleStatus status;
  final VoidCallback onTap;

  const VehicleSelectionCard({
    super.key,
    required this.title,
    required this.year,
    required this.licensePlate,
    required this.mileageText,
    // required this.imageUrl,
    required this.isSelected,
    // required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F7FE) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor.withOpacity(0.3)
                : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Thumbnail Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "imageUrl",
                    width: 70,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 55,
                      color: AppColors.primaryColor,
                      child: const Icon(Icons.two_wheeler, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title, Year & License Plate Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Tahun $year',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // License Plate Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          licensePlate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Selection Circle Checkbox
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primaryColor
                        : const Color(0xFFEAEFF8),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
            const Divider(),
            // Footer: Mileage & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.speed, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      "${mileageText} KM",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                // _buildStatusPill(status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(VehicleStatus status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case VehicleStatus.waktunyaServis:
        bg = const Color(0xFFFFEBEA);
        text = const Color(0xFFD32F2F);
        label = 'Waktunya Servis';
        break;
      case VehicleStatus.gantiOli:
        bg = const Color(0xFFFFEBEA);
        text = const Color(0xFFD32F2F);
        label = 'Ganti Oli';
        break;
      case VehicleStatus.kondisiPrima:
        bg = const Color(0xFFE8F5E9);
        text = const Color(0xFF2E7D32);
        label = 'Kondisi Prima';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
