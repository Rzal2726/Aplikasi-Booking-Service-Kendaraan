import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_vehicle_controller.dart';

class BookVehicleView extends GetView<BookVehicleController> {
  const BookVehicleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookVehicleView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BookVehicleView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
