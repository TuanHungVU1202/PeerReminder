import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/AbstractTaskList.dart';
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';
import 'package:peer_reminder_flutter/tasks/ViewTaskPage.dart';
import 'package:peer_reminder_flutter/tasks/model/TaskStatus.dart';
import 'package:peer_reminder_flutter/tasks/provider/BodyTaskListStateProvider.dart';
import 'package:provider/provider.dart';

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

    // if (widget.shouldRefresh) {
    //   refreshTaskList();
    //   widget.shouldRefresh = false;
    // }

    Scaffold mainScaffold = Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingAction(rootTaskListTitle: largeTitle),
      body: createRefreshableBody(),
    );

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        // To round the corners
        child: mainScaffold);
  }

  RefreshIndicator createRefreshableBody() {
    BodyTaskListStateProvider bodyTaskListState =
        Provider.of<BodyTaskListStateProvider>(context, listen: true);
    return RefreshIndicator(
        onRefresh: () => bodyTaskListState.fetchBodyTaskList(),
        child: createYourTaskSliverBody());
  }

  // -------------------------------------------------------------------
  // UI Components
  // CupertinoContextMenu createTaskContextMenu(int itemIndex) {
  //   BodyTaskListStateProvider bodyTaskListState =
  //       Provider.of<BodyTaskListStateProvider>(context, listen: true);
  //
  //   List<Task> filteredTaskList = bodyTaskListState.getFilteredTaskList;
  //
  //   return CupertinoContextMenu(
  //     actions: <Widget>[
  //       CupertinoContextMenuAction(
  //         onPressed: () {
  //           Navigator.of(context, rootNavigator: true).pop();
  //           editTask(context, filteredTaskList[itemIndex]);
  //         },
  //         isDefaultAction: true,
  //         trailingIcon: Icons.edit,
  //         child: const Text('Edit'),
  //       ),
  //       CupertinoContextMenuAction(
  //         onPressed: () {
  //           Navigator.of(context, rootNavigator: true).pop();
  //           bodyTaskListState.archiveTask(
  //               filteredTaskList[itemIndex], itemIndex);
  //           // FIXME: remove when archive task, and rebuild widget
  //           // removeTaskFromList(itemIndex);
  //         },
  //         trailingIcon: CupertinoIcons.archivebox,
  //         child: const Text('Archive'),
  //       ),
  //       CupertinoContextMenuAction(
  //         onPressed: () {
  //           Navigator.of(context, rootNavigator: true).pop();
  //           // FIXME: rebuild to show latest trailing icon
  //           bodyTaskListState.markAsDoneTask(filteredTaskList[itemIndex]);
  //         },
  //         trailingIcon: Icons.done,
  //         child: const Text('Mark as Done'),
  //       ),
  //       // FIXME: check if email or phone valid/available/etc.
  //       CupertinoContextMenuAction(
  //         onPressed: () {
  //           Navigator.of(context, rootNavigator: true).pop();
  //           launchDialer(filteredTaskList[itemIndex].phoneNo);
  //         },
  //         trailingIcon: CupertinoIcons.phone,
  //         child: const Text('Call peer'),
  //       ),
  //       CupertinoContextMenuAction(
  //         onPressed: () {
  //           Navigator.of(context, rootNavigator: true).pop();
  //           launchEmail(filteredTaskList[itemIndex].email);
  //         },
  //         trailingIcon: CupertinoIcons.mail,
  //         child: const Text('Email peer'),
  //       ),
  //     ],
  //     child: TaskTile(
  //       task: filteredTaskList[itemIndex],
  //       isPreviewTask: false,
  //       itemIndex,
  //       isEnableLeading: true,
  //       isEnableContact: true,
  //       rootTaskList: YourTaskPage(shouldRefresh: true),
  //       rootTaskListTitle: largeTitle,
  //     ),
  //     previewBuilder: (context, animation, child) {
  //       // Preview only => isPreview = true, isEnableLeading = false
  //       return ViewTaskPage(
  //         task: filteredTaskList[itemIndex],
  //         isEnableLeading: false,
  //         isPreview: true,
  //         isEnableContact: true,
  //       );
  //     },
  //   );
  // }

  // Future<bool> onConfirmDeleteTask() async {
  //   return await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoActionSheet(
  //         title: const Text('Delete Confirmation'),
  //         message: const Text('This task will be deleted. Continue?'),
  //         actions: <Widget>[
  //           CupertinoActionSheetAction(
  //             child: const Text('Delete', style: TextStyle(color: Colors.red)),
  //             onPressed: () {
  //               Navigator.pop(context, true);
  //             },
  //           ),
  //         ],
  //         cancelButton: CupertinoActionSheetAction(
  //           isDefaultAction: true,
  //           onPressed: () {
  //             Navigator.pop(context, false);
  //           },
  //           child: const Text('Cancel'),
  //         )),
  //   );
  // }

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
