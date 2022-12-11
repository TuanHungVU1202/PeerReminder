import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/ITaskItemIcon.dart';

class TaskStatus implements TaskItemIcon{
  // Task Statuses
  final Map<String, IconData> _taskStatusIconMap = {
    "TODO": Icons.question_mark,
    "In Progress": Icons.pending,
    "Done": Icons.done,
    "Archived": Icons.archive_rounded,
  };

  @override
  IconData? getItemIcon(String taskItemStr) {
    return _taskStatusIconMap[taskItemStr];
  }

  @override
  List<String> getItemListStr() {
    return _taskStatusIconMap.keys.toList();
  }
}