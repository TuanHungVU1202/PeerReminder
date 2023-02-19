import 'package:flutter/material.dart';

import '../../common/SharePrefService.dart';

class LocaleProvider with ChangeNotifier {
  String languageCode = sharedPrefs.getLocale().languageCode;

  void onSelect(String newLanguageCode) {
    languageCode = newLanguageCode;
    notifyListeners();
  }
}