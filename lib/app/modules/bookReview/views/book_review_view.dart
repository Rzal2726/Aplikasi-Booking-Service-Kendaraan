import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/book_review_controller.dart';

class BookReviewView extends GetView<BookReviewController> {
  const BookReviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookReviewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BookReviewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
