import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Local imports
import 'package:peer_reminder_flutter/tasks/AbstractTaskList.dart';
import 'package:peer_reminder_flutter/tasks/ViewTaskPage.dart';
import '../common/UIUtil.dart';
import '../common/Util.dart';
import 'component/TaskTile.dart';
import 'model/Task.dart';

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
      body: createRefreshableBody(bodyWidgetList),
    );
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
            // FIXME: rebuild to show latest trailing icon
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
        isPreviewTask: true,
        itemIndex,
        isEnableLeading: true,
        isEnableContact: false,
      ),
      previewBuilder: (context, animation, child) {
        // Preview only => isPreview = true, isEnableLeading = false
        return ViewTaskPage(
          task: filteredTaskList[itemIndex],
          isEnableLeading: false,
          isPreview: true,
          isEnableContact: false,
        );
      },
    );
  }

  @override
  Slidable createSlidableTask(int itemIndex) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      startActionPane: ActionPane(
        motion: const DrawerMotion(),

        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: (context) =>
                launchDialer(filteredTaskList[itemIndex].phoneNo),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.call,
            label: 'Call Peer',
          ),
          SlidableAction(
            onPressed: (context) => _showMoreActionSheet(context),
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.menu,
            label: 'More',
          ),
        ],
      ),

      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _addToCalendar(filteredTaskList[itemIndex]),
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.calendar_month,
            label: 'Add to Calendar',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: createTaskContextMenu(itemIndex),
    );
  }

  void _showMoreActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('More Contact Options'),
        message: const Text('Choose from the following contact options'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('Email'),
            onPressed: () {
              Navigator.pop(context, 'Email');
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Sms'),
            onPressed: () {
              Navigator.pop(context, 'Sms');
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Others'),
            onPressed: () {
              Navigator.pop(context, 'Others');
            },
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // Callbacks
  void _addToCalendar(Task task) {
    Add2Calendar.addEvent2Cal(
      UIUtil.buildEventFromTask(task),
    );
  }
}
