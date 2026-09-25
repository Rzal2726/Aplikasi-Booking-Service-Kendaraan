import 'package:get/get.dart';

import '../controllers/book_schedule_controller.dart';

class BookScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookScheduleController>(
      () => BookScheduleController(),
    );
  }
}
