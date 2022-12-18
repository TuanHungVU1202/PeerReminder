import 'package:flutter/material.dart';

abstract class Constant {
  static const double FONTSIZE_L = 15;
  static const double FONTSIZE_XL = 18;
  static const double FONTSIZE_XXL = 25;

  static const String DATE_FORMAT = "dd-MM-yyyy";
  static const String DATETIME_FORMAT = "dd-MM-yyyy hh:mm";

  // API URLS
  static const String TASK_LIST_BASE = "http://localhost:8080/task";
}