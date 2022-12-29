import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/common/Constant.dart';

abstract class UIConstant {
  static TextStyle kBiggerFont = const TextStyle(fontSize: Constant.kFontSizeXXL);
  static TextStyle kTitleFont = const TextStyle(fontSize: Constant.kFontSizeXL);
  static TextStyle kSubTitleFont = const TextStyle(fontSize: Constant.kFontSizeXL);

  static Color kBackgroundColor = const Color(0xFFD2FFF4);
  static Color kPrimaryColor = const Color(0xFF2D5D70);
  static Color kSecondaryColor = const Color(0xFF265DAB);
}