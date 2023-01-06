import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:peer_reminder_flutter/tasks/component/IBodyTaskList.dart';
import 'package:provider/provider.dart';

// Local imports
import '../TaskFormPage.dart';
import '../ViewTaskPage.dart';
import '../YourTaskPage.dart';
import '../model/Task.dart';
import '../provider/BodyTaskListProvider.dart';
import 'TaskTile.dart';

String largeTitle = "Your Tasks";

class BodyTaskListYourTasks extends StatelessWidget implements IBodyTaskList {
  const BodyTaskListYourTasks({super.key});

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
  Slidable createSlidableTask(int itemIndex, BuildContext context) {
    BodyTaskListProvider bodyTaskListProvider =
        Provider.of<BodyTaskListProvider>(context, listen: true);
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      startActionPane: ActionPane(
        motion: const DrawerMotion(),

        dismissible: DismissiblePane(confirmDismiss: () async {
          Future<bool> isConfirmed = onConfirmDeleteTask(context);
          return Future(() => isConfirmed);
        }, onDismissed: () {
          bodyTaskListProvider.deleteTask(itemIndex);
        }),

        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: (context) => bodyTaskListProvider.onPressedDelete(
                itemIndex, onConfirmDeleteTask(context)),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.notifications_active_outlined,
            label: 'Notify Peer',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: createTaskContextMenu(itemIndex, context),
    );
  }

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
            editTask(context, filteredTaskList[itemIndex]);
          },
          isDefaultAction: true,
          trailingIcon: Icons.edit,
          child: const Text('Edit'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            bodyTaskListProvider.archiveTask(
                filteredTaskList[itemIndex], itemIndex);
            // FIXME: remove when archive task, and rebuild widget
            // removeTaskFromList(itemIndex);
          },
          trailingIcon: CupertinoIcons.archivebox,
          child: const Text('Archive'),
        ),
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
  Future<bool> onConfirmDeleteTask(BuildContext context) async {
    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Delete Confirmation'),
          message: const Text('This task will be deleted. Continue?'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          )),
    );
  }

  void doNothing(BuildContext context) {
    print("abc");
  }

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
