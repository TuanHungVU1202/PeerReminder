import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/common/Constant.dart';

abstract class UIConstant {
  static TextStyle biggerFont = const TextStyle(fontSize: Constant.FONTSIZE_XXL);
  static TextStyle titleFont = const TextStyle(fontSize: Constant.FONTSIZE_XL);
  static TextStyle subTitleFont = const TextStyle(fontSize: Constant.FONTSIZE_XL);

  static Color kBackgroundColor = const Color(0xFFD2FFF4);
  static Color kPrimaryColor = const Color(0xFF2D5D70);
  static Color kSecondaryColor = const Color(0xFF265DAB);
}