import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

  // -------------------------------------------------------------------
  // UI Components
  @override
  SliverList createTaskSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) return const Divider(height: 0, color: Colors.grey);

          int itemIndex = index ~/ 2;
          return createSlidableTask(itemIndex);
        },
      ),
    );
  }

  // TODO: create corresponding callbacks for each menu selection
  @override
  CupertinoContextMenu createTaskContextMenu(int itemIndex) {
    return CupertinoContextMenu(
      actions: <Widget>[
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            markAsDoneTask(task);
          },
          trailingIcon: Icons.done,
          child: const Text('Mark as Done'),
        ),
        // FIXME: check if email or phone valid/available/etc.
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            launchDialer(task.phoneNo);
          },
          trailingIcon: CupertinoIcons.phone,
          child: const Text('Call peer'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            launchEmail(task.email);
          },
          trailingIcon: CupertinoIcons.mail,
          child: const Text('Email peer'),
        ),
      ],
      child: TaskTile(
        task: task,
        isPreviewTask: true,
        filteredTaskList,
        itemIndex,
        isEnableLeading: true,
        isEnableContact: false,
      ),
      previewBuilder: (context, animation, child) {
        // Preview only => isPreview = true, isEnableLeading = false
        return ViewTaskPage(
          task: task,
          isEnableLeading: false,
          isPreview: true,
          isEnableContact: false,
        );
      },
    );
  }

  // ---------------------------------------------------------
  // Callbacks
}
