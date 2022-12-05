import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/NewTaskPage.dart';
import 'package:permission_handler/permission_handler.dart';

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

            return _onSwipeTask(index);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        tooltip: 'Add Your Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Components
  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const NewTaskPage(),
      ),
    );
  }

  Dismissible _onSwipeTask(int index){
    final item = _taskList[index];
    return Dismissible(
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify widgets.
      key: Key(item),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) {
        // print(direction);
        // Remove the item from the data source.
        setState(() {
          _taskList.removeAt(index);
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$item dismissed')));
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title: Text(
          _taskList[index],
          style: _biggerFont,
        ),
      ),
    );
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