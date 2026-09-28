import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/app/components/AppIcon.dart';
import 'package:project/app/const/appcolors.dart';

class BookAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;

  const BookAppbar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleSpacing: showBackButton ? 0 : 16,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
              onPressed: () {
                if (onBack != null) {
                  onBack!();
                } else {
                  Get.back();
                }
              },
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIcon(size: 28, iconSize: 18),
          const SizedBox(width: 8),
          Flexible(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "MotoServ",
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const TextSpan(
                    text: " / ",
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4.0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF475569),
                size: 24,
              ),
              onPressed: () {},
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
