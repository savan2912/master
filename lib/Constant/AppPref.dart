import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static SharedPreferences? _prefs;

  // Key Constants
  static const String keyCityId = "selected_city_id";
  static const String keyCityName = "selected_city_name";
  static const String keyUserId = "userId";
  static const String keyProfileName = "profileName";
  static const String keyProfileEmail = "profileEmail";
  static const String keyProfileImage = "profileImage";

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setCity(int id, String name) async {
    await _prefs?.setInt(keyCityId, id);
    await _prefs?.setString(keyCityName, name);
  }

  static Future<void> setUserId(String userId) async {
    await _prefs?.setString(keyUserId, userId);
  }

  static Future<void> setProfileData(String name,String email,String image) async {
    await _prefs?.setString(keyProfileName, name);
    await _prefs?.setString(keyProfileEmail, email);
    await _prefs?.setString(keyProfileImage, image);
  }

  static int get cityId => _prefs?.getInt(keyCityId) ?? 0;
  static String get cityName => _prefs?.getString(keyCityName) ?? "Select City";
  static String get userId => _prefs?.getString(keyUserId) ?? "";

  static String get profileName => _prefs?.getString(keyProfileName) ?? "";
  static String get profileEmail => _prefs?.getString(keyProfileEmail) ?? "";
  static String get profileImage => _prefs?.getString(keyProfileImage) ?? "";



}