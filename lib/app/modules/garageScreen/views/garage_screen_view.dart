import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:project/app/components/AppIcon.dart';
import 'package:project/app/components/buttons/buttonPrimary.dart';
import 'package:project/app/components/cards/cardBasic.dart';
import 'package:project/app/components/cards/emptyCard.dart';
import 'package:project/app/const/appcolors.dart';

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
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: vehicleList.length,
              itemBuilder: (context, index) {
                final vehicle = vehicleList[index];
                return vehicleCard(
                  number: vehicle['number'] ?? "",
                  name: vehicle['brand'] ?? "",
                  year: vehicle['year'].toString(),
                  odometer: vehicle['odometer'].toString(),
                );
              },
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
          Text(controller.vehicleList.toString()),
        ],
      ),
    );
  }

  Widget vehicleCard({
    required String number,
    required String name,
    required String year,
    required String odometer,
  }) {
    return BasicCard(
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
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                  onPressed: () {},
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(24),
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
          ],
        ),
      ),
    );
  }
}
