import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/NewTaskPage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/Util.dart';


class YourTaskPage extends StatefulWidget {
  const YourTaskPage({super.key});

  @override
  State<YourTaskPage> createState() => _YourTaskPageState();
}

class _YourTaskPageState extends State<YourTaskPage> {

  void _addNewTask() {
    Navigator.push (
      context,
      MaterialPageRoute (
        builder: (BuildContext context) => const NewTaskPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Requesting Contact permission for the first time
    requestPermission();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Tasks"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'Testing',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        tooltip: 'Add Your Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Private Utils
  Future<bool> requestPermission() async {
    var permission = Util.getContactPermission();

    if (await permission.isGranted){
      return true;
    }
    else {
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