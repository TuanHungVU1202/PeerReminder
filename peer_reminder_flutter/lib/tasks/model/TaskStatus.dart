import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/service/ITaskItemIcon.dart';

import '../../common/Util.dart';

enum TaskStatusEnum { todo, doing, done, archived }

class TaskStatus implements TaskItemIcon {
  // Task Statuses
  final Map<String, IconData> _taskStatusIconMap = {
    Util.capitalizeEnumValue(TaskStatusEnum.todo.name): Icons.question_mark,
    Util.capitalizeEnumValue(TaskStatusEnum.doing.name): Icons.pending,
    Util.capitalizeEnumValue(TaskStatusEnum.done.name): Icons.done,
    Util.capitalizeEnumValue(TaskStatusEnum.archived.name): Icons.archive_rounded,
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
