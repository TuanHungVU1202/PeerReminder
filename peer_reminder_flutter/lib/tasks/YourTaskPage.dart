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

class YourTaskPage extends AbstractTaskList {
  const YourTaskPage({Key? key}) : super(key: key);

  @override
  YourTaskPageState createState() => YourTaskPageState();
}

class YourTaskPageState extends AbstractTaskListState<YourTaskPage> {
  @override
  String get largeTitle => "Your Tasks";

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyWidgetList = createBodyWidgetList();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const FloatingAction(),
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
            editTask(context, filteredTaskList[itemIndex]);
          },
          isDefaultAction: true,
          trailingIcon: Icons.edit,
          child: const Text('Edit'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            // FIXME: fix setState() called after dispose()
            Navigator.of(context, rootNavigator: true).pop();
            archiveTask(task, itemIndex);
            removeTaskFromList(itemIndex);
          },
          trailingIcon: CupertinoIcons.archivebox,
          child: const Text('Archive'),
        ),
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
        isPreviewTask: false,
        filteredTaskList,
        itemIndex,
        isEnableLeading: true,
        isEnableContact: true,
      ),
      previewBuilder: (context, animation, child) {
        // Preview only => isPreview = true, isEnableLeading = false
        return ViewTaskPage(
          task: task,
          isEnableLeading: false,
          isPreview: true,
          isEnableContact: true,
        );
      },
    );
  }

  // -------------------------------------------------------------------
  // Components' callbacks
  @override
  Future<void> swipeDownRefresh() async {
    // TODO: call get DB
    print("Swiped down");
  }

  // TODO: DB callbacks
  @override
  void deleteTask(int itemIndex) {
    // TODO: Call DB
    removeTaskFromList(itemIndex);
  }

  @override
  void editTask(BuildContext context, String taskTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            TaskFormPage(taskTitle, isCreate: false),
      ),
    );
  }

  @override
  void archiveTask(Task task, int itemIndex) {
    super.archiveTask(task, itemIndex);
    // TODO: after done, notify peer. Maybe cancel event as well?
  }
}

////////////////////////////////////////////////////////////////////////////////
class FloatingAction extends StatelessWidget {
  const FloatingAction({super.key});

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
        builder: (BuildContext context) =>
            const TaskFormPage("New Task", isCreate: true),
      ),
    );
  }
}
