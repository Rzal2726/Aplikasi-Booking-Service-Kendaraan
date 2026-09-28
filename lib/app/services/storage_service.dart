import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const String keyInitialized = 'app_data_initialized_v4';
  static const String keyVehicles = 'app_vehicles';
  static const String keyBrands = 'app_brands';
  static const String keyModels = 'app_models';
  static const String keyServices = 'app_services';
  static const String keySpareParts = 'app_spare_parts';
  static const String keySymptoms = 'app_symptoms';
  static const String keyActivities = 'app_activities';
  static const String keyUsers = 'app_users';
  static const String keyBookingDraft = 'app_booking_draft';
  static const String keyWorkshops = 'app_workshops';
  static const String keyBookStatus = 'app_book_status';

  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _initializeDefaultDataIfNeeded();
    return this;
  }

  Future<void> _initializeDefaultDataIfNeeded() async {
    final isInitialized = _prefs.getBool(keyInitialized) ?? false;

    // Check if initialization is needed or if new keys are missing
    if (!isInitialized ||
        !_prefs.containsKey(keyVehicles) ||
        !_prefs.containsKey(keySpareParts) ||
        !_prefs.containsKey(keySymptoms) ||
        !_prefs.containsKey(keyWorkshops)) {
      try {
        final jsonString = await rootBundle.loadString(
          'assets/json/dummyData.json',
        );
        final Map<String, dynamic> data = jsonDecode(jsonString);

        if (!_prefs.containsKey(keyVehicles) || !isInitialized) {
          await _prefs.setString(
            keyVehicles,
            jsonEncode(data['vehicles'] ?? []),
          );
        }
        if (!_prefs.containsKey(keyBrands) || !isInitialized) {
          await _prefs.setString(keyBrands, jsonEncode(data['brand'] ?? []));
        }
        if (!_prefs.containsKey(keyModels) || !isInitialized) {
          await _prefs.setString(keyModels, jsonEncode(data['model'] ?? []));
        }
        if (!_prefs.containsKey(keyServices) || !isInitialized) {
          await _prefs.setString(
            keyServices,
            jsonEncode(data['services'] ?? []),
          );
        }
        if (!_prefs.containsKey(keySpareParts) || !isInitialized) {
          await _prefs.setString(
            keySpareParts,
            jsonEncode(data['spareParts'] ?? []),
          );
        }
        if (!_prefs.containsKey(keySymptoms) || !isInitialized) {
          await _prefs.setString(
            keySymptoms,
            jsonEncode(data['symptoms'] ?? []),
          );
        }
        if (!_prefs.containsKey(keyActivities) || !isInitialized) {
          await _prefs.setString(
            keyActivities,
            jsonEncode(data['activities'] ?? []),
          );
        }
        if (!_prefs.containsKey(keyBookStatus) || !isInitialized) {
          await _prefs.setString(
            keyBookStatus,
            jsonEncode(data['status'] ?? []),
          );
        }
        if (!_prefs.containsKey(keyUsers) || !isInitialized) {
          await _prefs.setString(keyUsers, jsonEncode(data['users'] ?? []));
        }
        if (!_prefs.containsKey(keyWorkshops) || !isInitialized) {
          await _prefs.setString(
            keyWorkshops,
            jsonEncode(data['workshops'] ?? []),
          );
        }

        await _prefs.setBool(keyInitialized, true);
      } catch (e) {
        print("Error initializing storage data: $e");
      }
    }
  }

  // --- Vehicles ---
  List<Map<String, dynamic>> getVehicles() {
    final str = _prefs.getString(keyVehicles);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveVehicles(List<dynamic> list) async {
    await _prefs.setString(keyVehicles, jsonEncode(list));
  }

  Future<void> addVehicle(Map<String, dynamic> vehicle) async {
    final list = getVehicles();
    list.add(vehicle);
    await saveVehicles(list);
  }

  Future<void> updateVehicle(Map<String, dynamic> vehicle) async {
    final list = getVehicles();
    final index = list.indexWhere((v) => v['id'] == vehicle['id']);
    if (index != -1) {
      list[index] = vehicle;
      await saveVehicles(list);
    }
  }

  Future<void> deleteVehicle(dynamic id) async {
    final list = getVehicles();
    list.removeWhere((v) => v['id'] == id);
    await saveVehicles(list);
  }

  // --- Services ---
  List<Map<String, dynamic>> getServices() {
    final str = _prefs.getString(keyServices);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveServices(List<dynamic> list) async {
    await _prefs.setString(keyServices, jsonEncode(list));
  }

  // --- Spare Parts ---
  List<Map<String, dynamic>> getSpareParts() {
    final str = _prefs.getString(keySpareParts);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSpareParts(List<dynamic> list) async {
    await _prefs.setString(keySpareParts, jsonEncode(list));
  }

  // --- Symptoms ---
  List<String> getSymptoms() {
    final str = _prefs.getString(keySymptoms);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSymptoms(List<String> list) async {
    await _prefs.setString(keySymptoms, jsonEncode(list));
  }

  // --- Brands & Models ---
  List<Map<String, dynamic>> getBrands() {
    final str = _prefs.getString(keyBrands);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  List<Map<String, dynamic>> getModels() {
    final str = _prefs.getString(keyModels);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  // --- Activities ---
  List<Map<String, dynamic>> getActivities() {
    final str = _prefs.getString(keyActivities);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addActivity(Map<String, dynamic> activity) async {
    final list = getActivities();
    list.insert(0, activity);
    await _prefs.setString(keyActivities, jsonEncode(list));
  }

  // --- Workshops ---
  List<Map<String, dynamic>> getWorkshops() {
    final str = _prefs.getString(keyWorkshops);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  // --- Users ---
  List<Map<String, dynamic>> getUsers() {
    final str = _prefs.getString(keyUsers);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  // --- Users ---
  List<Map<String, dynamic>> getStatus() {
    final str = _prefs.getString(keyBookStatus);
    if (str == null || str.isEmpty) return [];
    try {
      final List decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  // --- Booking Draft Persistence ---
  Map<String, dynamic>? getBookingDraft() {
    final str = _prefs.getString(keyBookingDraft);
    if (str == null || str.isEmpty) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveBookingDraft(Map<String, dynamic> draft) async {
    await _prefs.setString(keyBookingDraft, jsonEncode(draft));
  }

  Future<void> clearBookingDraft() async {
    await _prefs.remove(keyBookingDraft);
  }

  // --- Reset to default (useful for resetting seed data) ---
  Future<void> resetToDefaults() async {
    await _prefs.clear();
    await _initializeDefaultDataIfNeeded();
  }
}
