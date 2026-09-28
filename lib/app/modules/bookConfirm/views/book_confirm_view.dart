import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_confirm_controller.dart';

class BookConfirmView extends GetView<BookConfirmController> {
  const BookConfirmView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookConfirmView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BookConfirmView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
