import 'package:flutter/widgets.dart';

class BasicBadge extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;
  final BorderRadiusGeometry? borderRadius;

  const BasicBadge({
    super.key,
    this.content = const Text('Badge'),
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
      ),
      child: content,
    );
  }
}
