import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/service/ITaskItemIcon.dart';

import '../../common/Util.dart';

enum TaskCategoryEnum { home, personal, school, financial, others }

class TaskCategory implements TaskItemIcon {
  // Task Categories
  final Map<String, IconData> _taskIconMap = {
    Util.capitalizeEnumValue(TaskCategoryEnum.home.name): Icons.home,
    Util.capitalizeEnumValue(TaskCategoryEnum.personal.name): Icons.person,
    Util.capitalizeEnumValue(TaskCategoryEnum.school.name): Icons.school,
    Util.capitalizeEnumValue(TaskCategoryEnum.financial.name): Icons.monetization_on,
    Util.capitalizeEnumValue(TaskCategoryEnum.others.name): Icons.question_mark,
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
