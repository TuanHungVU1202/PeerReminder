import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/Methods.dart';

final sharedPrefs = SharedPrefs();

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  // Init
  sharePrefsInit() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  // Locale
  Locale setLocale(String languageCode) {
    _sharedPrefs!.setString('languageCode', languageCode);
    return locale(languageCode);
  }

  Locale getLocale() {
    String languageCode = _sharedPrefs?.getString('languageCode') ?? "en";
    return locale(languageCode);
  }
}
