import 'package:be_sacha/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {

  static late final SharedPreferences sharedPreferences;

  // Initialize the shared preferences and app settings
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await SettingsService.init();
  }

  static Future<void> write(String key, dynamic value) async {
    if (value is String) {
      await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      await sharedPreferences.setBool(key, value);
    } else if (value is int) {
      await sharedPreferences.setInt(key, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      await sharedPreferences.setStringList(key, value);
    }
  }

  static dynamic read(String key) {
    return sharedPreferences.get(key);
  }

  static Future<void> clear() async {
    await sharedPreferences.clear();
  }

  static Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }
}
