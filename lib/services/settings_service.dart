import 'package:be_sacha/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SettingsService {

  static final Map<String, dynamic> _defaultSettings = {'brightnessMode': 'system', 'rules': false};

  // Initialize the shared preferences and set the default settings
  static Future<void> init() async {
    for (String key in _defaultSettings.keys) {
      if (SharedPreferencesService.read(key) == null) {
        dynamic value = _defaultSettings[key];
        await SharedPreferencesService.write(key, value);
      }
    }
  }

  static Future<void> setBrightnessMode(BuildContext context, String value) async {
    if (value != 'system' && value != 'light' && value != 'dark') {
      throw 'Invalid value for brightnessMode';
    }
    await SharedPreferencesService.write('brightnessMode', value);
    if (context.mounted) {
      BeSacha.updateTheme(context);
    }
  }

  static String getBrightnessMode() {
    return SharedPreferencesService.read('brightnessMode') as String;
  }
}
