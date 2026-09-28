import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:project/app/modules/accountScreen/controllers/account_screen_controller.dart';
import 'package:project/app/modules/activityScreen/controllers/activity_screen_controller.dart';
import 'package:project/app/modules/garageScreen/controllers/garage_screen_controller.dart';
import 'package:project/app/modules/serviceScreen/controllers/service_screen_controller.dart';

class HomeScreenController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxString appBarTitle = "Home".obs;
  final currentLocation = "Indonesia".obs;
  final isLoadingLocation = false.obs;

  final garageController = Get.find<GarageScreenController>();
  final serviceController = Get.find<ServiceScreenController>();
  final activityController = Get.find<ActivityScreenController>();
  final accountController = Get.find<AccountScreenController>();

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoadingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLoadingLocation.value = false;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );

      try {
        final placemarks = await Geocoding().placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          // Priority: subAdministrativeArea (Kabupaten/Kota), then locality, then administrativeArea
          String city =
              place.subAdministrativeArea ??
              place.locality ??
              place.administrativeArea ??
              '';
          if (city.isEmpty) {
            city = place.locality ?? place.administrativeArea ?? 'Bandung';
          }
          // Remove prefixes like "Kota " or "Kabupaten " for a clean badge label
          city = city
              .replaceAll(
                RegExp(r'^(Kota|Kabupaten|Kab\.)\s+', caseSensitive: false),
                '',
              )
              .trim();
          if (city.isNotEmpty) {
            currentLocation.value = city;
          }
        }
      } catch (e) {
        debugPrint('Geocoding error: $e');
      }
    } catch (e) {
      debugPrint('Geolocator error: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
