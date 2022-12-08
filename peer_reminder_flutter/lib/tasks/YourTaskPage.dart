import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/NewTaskPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;
import 'package:peer_reminder_flutter/common/Util.dart';

class YourTaskPage extends StatefulWidget {
  const YourTaskPage({super.key});

  @override
  State<YourTaskPage> createState() => _YourTaskPageState();
}

class _YourTaskPageState extends State<YourTaskPage> {
  // FIXME: finalize this, query from DB
  final _taskList = List<String>.generate(10000, (i) => 'Item $i');
  final _biggerFont = const TextStyle(fontSize: constant.FONTSIZE_XL);

  @override
  Widget build(BuildContext context) {
    // Requesting Contact permission for the first time
    _requestPermission();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Tasks"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            // Add divider if position is odd
            if (i.isOdd) return const Divider();
            final index = i ~/ 2;

            return _onSlideTask(index);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        tooltip: 'Add Your Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  // -------------------------------------------------------------------
  // UI Components
  Slidable _onSlideTask(int itemIndex) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      startActionPane: ActionPane(
        motion: const DrawerMotion(),

        dismissible: DismissiblePane(confirmDismiss: () async {
          Future<bool> isConfirmed = _onConfirmDeleteTask();
          return Future(() => isConfirmed);
        }, onDismissed: () {
          _deleteTask(itemIndex);
        }),

        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: (context) => _onPressedDelete(itemIndex),
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
      child: _createTaskContextMenu(itemIndex),
    );
  }

  // TODO: create corresponding callbacks for each menu selection
  CupertinoContextMenu _createTaskContextMenu(int itemIndex) {
    return CupertinoContextMenu(
      actions: <Widget>[
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDefaultAction: true,
          trailingIcon: CupertinoIcons.arrow_turn_down_left,
          child: const Text('Edit'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.pop(context);
          },
          trailingIcon: CupertinoIcons.archivebox,
          child: const Text('Archive'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.pop(context);
          },
          trailingIcon: CupertinoIcons.phone,
          child: const Text('Call peer'),
        ),
      ],
      child: _createTaskMaterial(itemIndex),
      // TODO: create preview function here
      previewBuilder: (context, animation, child) {
        return const Dialog(
          child: Text("This is a preview"),
        );
      },
    );
  }

  Material _createTaskMaterial(int itemIndex) {
    return Material(
      // Create Material widget for each ListTile
      child: ListTile(
        title: Text(
          _taskList[itemIndex],
          style: _biggerFont,
        ),
      ),
    );
  }

  InkWell _createConfirmCancelButton(double width, double height) {
    return InkWell(
      child: Container(
        width: width,
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: const Center(
          child: Text(
            'Cancel',
            style: TextStyle(
                fontSize: constant.FONTSIZE_XL, color: Colors.lightBlue),
          ),
        ),
      ),
      // false means this pop return value bool = false
      onTap: () => Navigator.pop(context, false),
    );
  }

  InkWell _createConfirmDeleteButton(double width, double height) {
    return InkWell(
      child: Container(
        width: width,
        // height: height*0.3,
        padding: const EdgeInsets.all(5.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: const Center(
          child: Text(
            'Delete',
            style: TextStyle(fontSize: constant.FONTSIZE_XL, color: Colors.red),
          ),
        ),
      ),
      // true means this pop return value bool = true
      onTap: () => Navigator.pop(context, true),
    );
  }

  // -------------------------------------------------------------------
  // Components' callbacks
  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NewTaskPage(),
      ),
    );
  }

  void doNothing(BuildContext context) {
    print("abc");
  }

  Future<void> _onPressedDelete(int itemIndex) async {
    Future<bool> isConfirmed = _onConfirmDeleteTask();

    if (await isConfirmed) {
      _deleteTask(itemIndex);
    }
  }

  Future<bool> _onConfirmDeleteTask() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            elevation: 0.0,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: width,
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Column(
                    children: [
                      // Text information
                      const Text("This task will be deleted"),
                      const Divider(),
                      // Delete button
                      _createConfirmDeleteButton(width, height),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Cancel button
                _createConfirmCancelButton(width, height),
              ],
            ));
      },
    );
  }

  void _deleteTask(int itemIndex) {
    // TODO: Call DB
    setState(() {
      _taskList.removeAt(itemIndex);
    });
  }

  // -------------------------------------------------------------------
  // Private Utils
  Future<bool> _requestPermission() async {
    var permission = Util.getContactPermission();

    if (await permission.isGranted) {
      return true;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Contacts Permission denied'),
                content: const Text('Please enable contacts access '
                    'permission in system settings to search for peer contacts'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('Maybe later'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: const Text('Open Settings'),
                    onPressed: () => openAppSettings(),
                  )
                ],
              ));
    }
    return true;
  }
}
