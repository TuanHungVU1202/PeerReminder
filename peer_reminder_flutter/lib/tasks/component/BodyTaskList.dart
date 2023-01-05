import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// Local imports
import '../provider/BodyTaskListStateProvider.dart';

class BodyTaskList extends StatelessWidget {
  const BodyTaskList({super.key});

  // FIXME: return SliverList here
  // https://medium.com/flutter-community/flutter-statemanagement-with-provider-ee251bbc5ac1
  // https://stackoverflow.com/questions/56691331/how-to-use-flutter-provider-in-a-statefulwidget
  // https://stackoverflow.com/questions/66619564/flutter-provider-initializing-a-state-with-a-constructor
  @override
  Widget build(BuildContext context) {
    BodyTaskListStateProvider bodyTaskListState =
        Provider.of<BodyTaskListStateProvider>(context, listen: true);
    // return ChangeNotifierProvider<BodyTaskListStateProvider>(
    //   create: (_) => BodyTaskListStateProvider(),
    // );

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: bodyTaskListState.getFilteredTaskList.length,
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

  Slidable createSlidableTask(int itemIndex, BuildContext context) {
    BodyTaskListStateProvider bodyTaskListState =
        Provider.of<BodyTaskListStateProvider>(context, listen: true);
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      startActionPane: ActionPane(
        motion: const DrawerMotion(),

        dismissible: DismissiblePane(confirmDismiss: () async {
          Future<bool> isConfirmed = onConfirmDeleteTask(context);
          return Future(() => isConfirmed);
        }, onDismissed: () {
          bodyTaskListState.deleteTask(itemIndex);
        }),

        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: (context) => bodyTaskListState.onPressedDelete(
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

  CupertinoContextMenu createTaskContextMenu(
      int itemIndex, BuildContext context) {
    return CupertinoContextMenu(
      actions: <Widget>[
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          isDefaultAction: true,
          trailingIcon: Icons.edit,
          child: const Text('Edit'),
        ),
      ],
      child: const Text("This is child"),
    );
  }

  void doNothing(BuildContext context) {
    print("abc");
  }
}
