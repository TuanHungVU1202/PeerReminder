import 'package:flutter/material.dart';

abstract class Constant {
  static const double kFontSizeL = 15;
  static const double kFontSizeXL = 18;
  static const double kFontSizeXXL = 25;

  static const String kDateFormat = "dd-MM-yyyy";
  static const String kDateTimeFormat = "dd-MM-yyyy hh:mm";

  // API URLS
  static const String kTaskListBase = "http://localhost:8080/task";
}