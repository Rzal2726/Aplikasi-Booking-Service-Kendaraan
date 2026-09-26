import 'package:flutter/material.dart';
import 'package:project/app/const/appcolors.dart';

class ButtonPrimary extends StatefulWidget {
  const ButtonPrimary({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.textColor,
    this.icon,
  });

  final Function() onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final Icon? icon;

  @override
  State<ButtonPrimary> createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<ButtonPrimary> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color ?? AppColors.primaryColor,
        foregroundColor: widget.textColor ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      onPressed: widget.onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.0,
        children: [
          Text(widget.text),
          if (widget.icon != null) ...[widget.icon!],
        ],
      ),
    );
  }
}
