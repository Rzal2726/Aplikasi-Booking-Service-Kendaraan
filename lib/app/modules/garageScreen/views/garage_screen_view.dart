import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:project/app/components/AppIcon.dart';
import 'package:project/app/components/buttons/buttonPrimary.dart';
import 'package:project/app/components/cards/cardBasic.dart';
import 'package:project/app/components/cards/emptyCard.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/routes/app_pages.dart';

import '../controllers/garage_screen_controller.dart';

class GarageScreenView extends GetView<GarageScreenController> {
  const GarageScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
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
                    final vehicle = vehicleList[index];
                    return vehicleCard(
                      number: vehicle['number'] ?? "",
                      name: vehicle['brand'] ?? "",
                      model: vehicle['model'] ?? "",
                      year: vehicle['year'].toString(),
                      odometer: vehicle['odometer'].toString(),
                    );
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

  Widget vehicleCard({
    required String number,
    required String name,
    required String model,
    required String year,
    required String odometer,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
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
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          number,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Text(
                        "$name $model",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Tahun ${year} • ${odometer} KM",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ButtonPrimary(
                    onPressed: () {
                      Get.toNamed(Routes.BOOK_SCREEN);
                    },
                    text: "Booking Servis",
                    icon: Icon(Icons.build),
                  ),
                ),
                ButtonPrimary(
                  color: Colors.grey.shade100,
                  onPressed: () {},
                  text: "Detail",
                  textColor: Colors.black,
                  icon: Icon(Icons.info, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
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
            modelDropdown(),
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

  Widget modelDropdown() {
    return DropdownMenu<String>(
      width: double.infinity, // Fills available container width
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
      dropdownMenuEntries: controller.modelList.map((data) {
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
