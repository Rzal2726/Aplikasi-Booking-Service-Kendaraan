import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:project/app/components/cards/badgeBasic.dart';
import 'package:project/app/components/cards/cardBasic.dart';
import 'package:project/app/const/appcolors.dart';
import 'package:project/app/services/formatter.dart';

import '../controllers/book_service_controller.dart';

class BookServiceView extends GetView<BookServiceController> {
  const BookServiceView({super.key});
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
          final vehicles = controller.selectedVehicle;
          final services = controller.serviceList;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final data = vehicles[index];
              return BasicCard(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.two_wheeler,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BasicBadge(
                                borderRadius: BorderRadius.circular(4),
                                content: Text(
                                  "MOTOR ${index + 1}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                backgroundColor: AppColors.primaryColor
                                    .withAlpha(25),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${data['brand']} ${data['model']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
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
                                      data['number'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.speed,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "${data['odometer']} KM",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
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
                    const SizedBox(height: 12),
                    Row(
                      spacing: 8,
                      children: [
                        BasicBadge(
                          borderRadius: BorderRadius.circular(8),
                          content: Text(
                            "1",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          backgroundColor: AppColors.primaryColor.withAlpha(25),
                        ),
                        Expanded(
                          child: const Text(
                            "PAKET SERVIS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                2, // Displays exactly 2 columns side-by-side
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: services.length,
                      itemBuilder: (context, serviceIndex) {
                        final service = services[serviceIndex];

                        // Check if this service is selected for this specific motor
                        final isSelected =
                            data['selectedServiceId'] == service['id'];

                        return ServicePackageCard(
                          title: service['name'],
                          description: service['description'],
                          price: service['price'],
                          icon: service['icon'] ?? Icons.build,
                          isSelected: isSelected,
                          onTap: () {
                            // Handle selection logic
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 8,
                      children: [
                        BasicBadge(
                          borderRadius: BorderRadius.circular(8),
                          content: Text(
                            "2",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          backgroundColor: AppColors.primaryColor.withAlpha(25),
                        ),
                        Expanded(
                          child: const Text(
                            "SUKU CADANG & OLI TAMBAHAN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget infoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF0284C7), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Pilih paket servis dan suku cadang untuk tiap motor secara mandiri. Kedua motor dapat dikerjakan secara bersamaan.",
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0F172A),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServicePackageCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ServicePackageCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon Header
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
                // Radio/Check Indicator
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey.shade300,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                height: 1.25,
              ),
            ),
            Spacer(),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Biaya: ',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ),
                Text(
                  formatRupiah(price),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primaryColor : Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
