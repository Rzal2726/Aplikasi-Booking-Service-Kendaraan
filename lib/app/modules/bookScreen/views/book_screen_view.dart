import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_screen_controller.dart';

class BookScreenView extends GetView<BookScreenController> {
  const BookScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookScreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BookScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
