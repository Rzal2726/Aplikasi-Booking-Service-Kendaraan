import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:project/app/components/cards/cardBasic.dart';

import '../controllers/account_screen_controller.dart';

class AccountScreenView extends GetView<AccountScreenController> {
  const AccountScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(padding: EdgeInsets.all(16), children: [UserCard()]),
    );
  }

  Widget UserCard() {
    return BasicCard(
      content: Row(
        spacing: 4,
        children: [
          Container(
            width: 60,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              child: Image.asset(
                width: 60,
                "",
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.account_circle, size: 60);
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "08123456789",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                Text(
                  "johndoe@gmail.com",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
