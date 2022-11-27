import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/NewTaskPage.dart';


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
}