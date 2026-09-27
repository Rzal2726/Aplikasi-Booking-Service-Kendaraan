import 'package:flutter/material.dart';

class BasicCard extends StatelessWidget {
  const BasicCard({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: content,
    );
  }
}
