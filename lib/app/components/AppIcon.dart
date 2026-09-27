import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project/app/const/appcolors.dart';

class AppIcon extends StatelessWidget {
  final double size;
  final double iconSize;
  const AppIcon({super.key, this.size = 40, this.iconSize = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primaryColor,
      ),
      child: Icon(Icons.two_wheeler, size: iconSize, color: Colors.white),
    );
  }
}
