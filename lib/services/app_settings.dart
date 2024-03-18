import 'package:be_sacha/services/local_storage.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AppSettings {

  static final Map<String, dynamic> _defaultSettings = {
    'brightnessMode': 'system',
  };

  // Initialize the shared preferences and set the default settings
  static Future<void> init() async {
    for (String key in _defaultSettings.keys) {
      if (LocalStorage.read(key) == null) {
        dynamic value = _defaultSettings[key];
        await LocalStorage.write(key, value);
      }
    }
  }

  static Future<void> setBrightnessMode(BuildContext context, String value) async {
    if (value != 'system' && value != 'light' && value != 'dark') {
      throw 'Invalid value for brightnessMode';
    }
    await LocalStorage.write('brightnessMode', value);
    if (context.mounted) {
      BeSacha.updateTheme(context);
    }
  }

  static String getBrightnessMode() {
    return LocalStorage.read('brightnessMode') as String;
  }
}
