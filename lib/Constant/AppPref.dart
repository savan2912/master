import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static SharedPreferences? _prefs;

  // Key Constants
  static const String keyCityId = "selected_city_id";
  static const String keyCityName = "selected_city_name";

  // Initialize (Aa tamara main.dart ma call karvu)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Setters
  static Future<void> setCity(int id, String name) async {
    await _prefs?.setInt(keyCityId, id);
    await _prefs?.setString(keyCityName, name);
  }
  static int get cityId => _prefs?.getInt(keyCityId) ?? 0;
  static String get cityName => _prefs?.getString(keyCityName) ?? "Select City";
}