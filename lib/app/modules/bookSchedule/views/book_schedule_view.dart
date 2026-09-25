import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_schedule_controller.dart';

class BookScheduleView extends GetView<BookScheduleController> {
  const BookScheduleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookScheduleView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BookScheduleView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
