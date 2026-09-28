import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const MainAppbar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(title),
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
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            )
          : null,
      // actions: [
      //   GestureDetector(
      //     onTap: () {
      //       // Handle profile button press
      //     },
      //     child: const CircleAvatar(
      //       backgroundColor: Colors.grey,
      //       child: Icon(Icons.person),
      //     ),
      //   ),
      //   const SizedBox(width: 16),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
