import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/components/AppIcon.dart';
import 'package:project/app/components/cards/badgeBasic.dart';
import 'package:project/app/const/appcolors.dart';

class HomeAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const HomeAppbar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppbarState extends State<HomeAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppIcon(size: 24, iconSize: 16),
          Text(
            "MotoServ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          BasicBadge(
            content: Row(
              spacing: 4,
              children: [
                Icon(Icons.location_pin, size: 16, color: Colors.grey.shade700),
                Text(
                  'Bandung',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.backgroundSwatch.shade200,
          ),
        ],
      ),
      centerTitle: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8.0,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
      leading: widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            )
          : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notification button press
          },
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            // Handle profile button press
          },
          child: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
