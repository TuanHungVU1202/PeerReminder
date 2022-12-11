import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/ITaskItemIcon.dart';

class TaskCategory implements TaskItemIcon {
  // Task Categories
  final Map<String, IconData> _taskIconMap = {
    "Home": Icons.home,
    "Personal": Icons.person,
    "School": Icons.school,
    "Financial": Icons.monetization_on,
    "Others": Icons.question_mark,
  };

  @override
  IconData? getItemIcon(String taskItemStr) {
    return _taskIconMap[taskItemStr];
  }

  @override
  List<String>? getItemListStr() {
    return _taskIconMap.keys.toList();
  }
}
