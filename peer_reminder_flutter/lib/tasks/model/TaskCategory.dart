import 'package:flutter/material.dart';

class TaskCategory {
  // Task Categories
  final Map<String, IconData> _taskIconMap = {
    "Home": Icons.home,
    "Personal": Icons.person,
    "School": Icons.school,
    "Financial": Icons.monetization_on,
    "Others": Icons.question_mark,
  };

  IconData? getTaskCategoryIcon(String taskCategory) {
    return _taskIconMap[taskCategory];
  }

  List<String> getTaskCategoryList() {
    return _taskIconMap.keys.toList();
  }
}
