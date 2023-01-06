import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../common/UIUtil.dart';
import '../ViewTaskPage.dart';
import '../model/Task.dart';
import '../provider/BodyTaskListProvider.dart';
import 'IBodyTaskList.dart';
import 'TaskTile.dart';

class BodyTaskListMyTasks extends StatelessWidget implements IBodyTaskList {
  const BodyTaskListMyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    BodyTaskListProvider bodyTaskListProvider =
        Provider.of<BodyTaskListProvider>(context, listen: true);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: bodyTaskListProvider.getFilteredTaskList.length,
        (context, index) {
          return Column(
            children: <Widget>[
              createSlidableTask(index, context),
              const Divider(height: 1)
            ],
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------------
  // UI Components

  @override
  CupertinoContextMenu createTaskContextMenu(
      int itemIndex, BuildContext context) {
    BodyTaskListProvider bodyTaskListProvider =
        Provider.of<BodyTaskListProvider>(context, listen: true);

    List<Task> filteredTaskList = bodyTaskListProvider.getFilteredTaskList;

    return CupertinoContextMenu(
      actions: <Widget>[
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            // FIXME: rebuild to show latest trailing icon
            bodyTaskListProvider.markAsDoneTask(filteredTaskList[itemIndex]);
          },
          trailingIcon: Icons.done,
          child: const Text('Mark as Done'),
        ),
        // FIXME: check if email or phone valid/available/etc.
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            bodyTaskListProvider
                .launchDialer(filteredTaskList[itemIndex].phoneNo);
          },
          trailingIcon: CupertinoIcons.phone,
          child: const Text('Call peer'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            bodyTaskListProvider.launchEmail(filteredTaskList[itemIndex].email);
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
  Slidable createSlidableTask(int itemIndex, BuildContext context) {
    BodyTaskListProvider bodyTaskListProvider =
        Provider.of<BodyTaskListProvider>(context, listen: true);

    List<Task> filteredTaskList = bodyTaskListProvider.getFilteredTaskList;

    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      startActionPane: ActionPane(
        motion: const DrawerMotion(),

        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: (context) => bodyTaskListProvider
                .launchDialer(filteredTaskList[itemIndex].phoneNo),
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
      child: createTaskContextMenu(itemIndex, context),
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
