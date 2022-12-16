import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/AbstractTaskList.dart';
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';
import 'package:peer_reminder_flutter/tasks/ViewTaskPage.dart';
import 'package:peer_reminder_flutter/tasks/model/TaskStatus.dart';

// Local imports
import 'TaskTile.dart';
import 'model/Task.dart';

class MyTaskPage extends AbstractTaskList {
  const MyTaskPage({Key? key}) : super(key: key);

  @override
  MyTaskPageState createState() => MyTaskPageState();
}

class MyTaskPageState extends AbstractTaskListState<MyTaskPage> {
  @override
  String get largeTitle => "My Tasks";

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgetList = createBodyWidgetList();

    return Scaffold(
      body: createRefreshableBody(bodyWidgetList),
    );
  }
}
