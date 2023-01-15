import 'package:flutter/material.dart';

import 'AppLocalization.dart';

Locale locale(String languageCode) {
  switch (languageCode) {
    case 'en':
      return const Locale('en', 'US');
    case 'vi':
      return const Locale('vi', "VN");
    default:
      return const Locale('en', 'US');
  }
}

String? getTranslated(BuildContext context, String key) {
  return AppLocalization.of(context)?.translate(key);
}

Map<String, String>? localizedMap(BuildContext context) =>
    AppLocalization.of(context)?.localizedMap();
