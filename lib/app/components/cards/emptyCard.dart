import 'package:flutter/material.dart';
import 'package:project/app/components/cards/cardBasic.dart';
import 'package:project/app/const/appcolors.dart';

class EmptyCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Widget? actionButton;
  final double iconSize;

  const EmptyCard({
    super.key,
    this.title = 'Data Tidak Ditemukan',
    this.message = 'Belum ada data yang tersedia saat ini.',
    this.icon = Icons.inbox_outlined,
    this.actionButton,
    this.iconSize = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      content: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 16.0),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6.0),

            // Message Body
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),

            // Optional Action Button (e.g., Reload or Add)
            if (actionButton != null) ...[
              const SizedBox(height: 16.0),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}
