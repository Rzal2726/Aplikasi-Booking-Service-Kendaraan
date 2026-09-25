import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_service_controller.dart';

class BookServiceView extends GetView<BookServiceController> {
  const BookServiceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookServiceView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BookServiceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
