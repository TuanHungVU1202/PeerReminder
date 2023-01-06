import 'package:flutter/material.dart';

// Local imports
import 'package:peer_reminder_flutter/tasks/AbstractTaskList.dart';

import 'component/BodyTaskListMyTasks.dart';

class MyTaskPage extends AbstractTaskList {
  MyTaskPage({Key? key, required shouldRefresh})
      : super(key: key, shouldRefresh: shouldRefresh);

  @override
  MyTaskPageState createState() => MyTaskPageState();
}

class MyTaskPageState extends AbstractTaskListState<MyTaskPage> {
  @override
  String get largeTitle => "My Tasks";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createRefreshableBody(),
    );
  }

  // Create and use state provider for main BodyTaskList
  @override
  Widget createBodyTaskList() {
    return const BodyTaskListMyTasks();
  }
}
