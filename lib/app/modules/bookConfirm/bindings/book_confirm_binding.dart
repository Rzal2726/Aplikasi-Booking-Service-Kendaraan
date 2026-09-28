import 'package:get/get.dart';

import '../controllers/book_confirm_controller.dart';

class BookConfirmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookConfirmController>(
      () => BookConfirmController(),
    );
  }
}
