import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/components/AppIcon.dart';
import 'package:project/app/components/cards/badgeBasic.dart';
import 'package:project/app/const/appcolors.dart';

class BookAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Function()? onBack;

  const BookAppbar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  State<BookAppbar> createState() => _HomeAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppbarState extends State<BookAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppIcon(size: 24, iconSize: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "MotoServ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " / ",
                  style: TextStyle(color: Colors.grey),
                ),
                TextSpan(
                  text: "${widget.title}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
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
          ? InkWell(
              child: const Icon(Icons.arrow_back),
              onTap: () {
                if (widget.onBack == null) {
                  Get.back();
                } else {
                  widget.onBack;
                }
              },
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
