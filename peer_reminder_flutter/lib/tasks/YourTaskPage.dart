import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/AbstractTaskList.dart';
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';
import 'package:peer_reminder_flutter/tasks/ViewTaskPage.dart';
import 'package:peer_reminder_flutter/tasks/model/TaskStatus.dart';

// Local imports
import 'component/TaskTile.dart';
import 'model/Task.dart';

class YourTaskPage extends AbstractTaskList {
  YourTaskPage({Key? key, required shouldRefresh})
      : super(key: key, shouldRefresh: shouldRefresh);

  @override
  YourTaskPageState createState() => YourTaskPageState();
}

class YourTaskPageState extends AbstractTaskListState<YourTaskPage> {
  @override
  String get largeTitle => "Your Tasks";

  @override
  Widget build(BuildContext context) {
    print("Rebuilding...");
    List<Widget> bodyWidgetList = createBodyWidgetList();

    if (widget.shouldRefresh) {
      refreshTaskList();
      widget.shouldRefresh = false;
    }

    Scaffold mainScaffold = Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingAction(rootTaskListTitle: largeTitle),
      body: createRefreshableBody(bodyWidgetList),
    );

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        // To round the corners
        child: mainScaffold);
  }

  // -------------------------------------------------------------------
  // UI Components
  @override
  CupertinoContextMenu createTaskContextMenu(int itemIndex) {
    return CupertinoContextMenu(
      actions: <Widget>[
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            editTask(context, filteredTaskList[itemIndex]);
          },
          isDefaultAction: true,
          trailingIcon: Icons.edit,
          child: const Text('Edit'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            archiveTask(filteredTaskList[itemIndex]);
            removeTaskFromList(itemIndex);
          },
          trailingIcon: CupertinoIcons.archivebox,
          child: const Text('Archive'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            markAsDoneTask(filteredTaskList[itemIndex]);
          },
          trailingIcon: Icons.done,
          child: const Text('Mark as Done'),
        ),
        // FIXME: check if email or phone valid/available/etc.
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            launchDialer(filteredTaskList[itemIndex].phoneNo);
          },
          trailingIcon: CupertinoIcons.phone,
          child: const Text('Call peer'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            launchEmail(filteredTaskList[itemIndex].email);
          },
          trailingIcon: CupertinoIcons.mail,
          child: const Text('Email peer'),
        ),
      ],
      child: TaskTile(
        task: filteredTaskList[itemIndex],
        isPreviewTask: false,
        itemIndex,
        isEnableLeading: true,
        isEnableContact: true,
        rootTaskList: YourTaskPage(shouldRefresh: true),
        rootTaskListTitle: largeTitle,
      ),
      previewBuilder: (context, animation, child) {
        // Preview only => isPreview = true, isEnableLeading = false
        return ViewTaskPage(
          task: filteredTaskList[itemIndex],
          isEnableLeading: false,
          isPreview: true,
          isEnableContact: true,
        );
      },
    );
  }

  // -------------------------------------------------------------------
  // Components' callbacks
  // FIXME: pass bool for YourTaskPage here to see if it should refresh page
  @override
  void editTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TaskFormPage(
          task: task,
          isCreate: false,
          rootTaskList: YourTaskPage(shouldRefresh: true),
          rootTaskListTitle: largeTitle,
        ),
      ),
    );
  }

  @override
  void archiveTask(Task task) {
    super.archiveTask(task);
    // TODO: after done, notify peer. Maybe cancel event as well?
  }
}

////////////////////////////////////////////////////////////////////////////////
class FloatingAction extends StatelessWidget {
  const FloatingAction({super.key, required this.rootTaskListTitle});

  final String rootTaskListTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 60),
          child: FloatingActionButton(
            onPressed: () {
              _onPressedAddNewTask(context);
            },
            backgroundColor: Colors.lightBlue,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------
  // Components' callbacks
  void _onPressedAddNewTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TaskFormPage(
          task: Task.createNew("New Task"),
          isCreate: true,
          rootTaskList: YourTaskPage(shouldRefresh: true),
          rootTaskListTitle: rootTaskListTitle,
        ),
      ),
    );
  }
}
