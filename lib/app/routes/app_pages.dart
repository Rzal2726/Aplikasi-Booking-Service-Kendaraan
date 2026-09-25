import 'package:get/get.dart';

import '../modules/accountScreen/bindings/account_screen_binding.dart';
import '../modules/accountScreen/views/account_screen_view.dart';
import '../modules/activityScreen/bindings/activity_screen_binding.dart';
import '../modules/activityScreen/views/activity_screen_view.dart';
import '../modules/bookReview/bindings/book_review_binding.dart';
import '../modules/bookReview/views/book_review_view.dart';
import '../modules/bookSchedule/bindings/book_schedule_binding.dart';
import '../modules/bookSchedule/views/book_schedule_view.dart';
import '../modules/bookScreen/bindings/book_screen_binding.dart';
import '../modules/bookScreen/views/book_screen_view.dart';
import '../modules/bookService/bindings/book_service_binding.dart';
import '../modules/bookService/views/book_service_view.dart';
import '../modules/bookVehicle/bindings/book_vehicle_binding.dart';
import '../modules/bookVehicle/views/book_vehicle_view.dart';
import '../modules/garageScreen/bindings/garage_screen_binding.dart';
import '../modules/garageScreen/views/garage_screen_view.dart';
import '../modules/homeScreen/bindings/home_screen_binding.dart';
import '../modules/homeScreen/views/home_screen_view.dart';
import '../modules/serviceScreen/bindings/service_screen_binding.dart';
import '../modules/serviceScreen/views/service_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME_SCREEN,
      page: () => const HomeScreenView(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_SCREEN,
      page: () => const ServiceScreenView(),
      binding: ServiceScreenBinding(),
    ),
    GetPage(
      name: _Paths.GARAGE_SCREEN,
      page: () => const GarageScreenView(),
      binding: GarageScreenBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_SCREEN,
      page: () => const BookScreenView(),
      binding: BookScreenBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_SERVICE,
      page: () => const BookServiceView(),
      binding: BookServiceBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_SCHEDULE,
      page: () => const BookScheduleView(),
      binding: BookScheduleBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_REVIEW,
      page: () => const BookReviewView(),
      binding: BookReviewBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_VEHICLE,
      page: () => const BookVehicleView(),
      binding: BookVehicleBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY_SCREEN,
      page: () => const ActivityScreenView(),
      binding: ActivityScreenBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_SCREEN,
      page: () => const AccountScreenView(),
      binding: AccountScreenBinding(),
    ),
  ];
}
