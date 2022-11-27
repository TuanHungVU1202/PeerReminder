import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/common/constant.dart' as Constant;

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  NewTaskFormState createState() {
    return NewTaskFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class NewTaskFormState extends State<NewTaskPage> {
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        actions: <Widget>[
          createSaveButton(),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // List TextFormField here
              createTaskNameField(),
              createTaskStartTimeField(),
              createTaskEndTimeField(),
              createTaskNoteField(),
              createTaskPeerField(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField createTaskNameField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.task),
        hintText: 'Enter task name',
        labelText: 'Task Name',
      ),
    );
  }

  // TODO: time picker
  TextFormField createTaskStartTimeField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.access_time),
        hintText: 'Enter starting time',
        labelText: 'Start time',
      ),
    );
  }

  // TODO: time picker
  TextFormField createTaskEndTimeField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.access_time_filled),
        hintText: 'Enter ending time',
        labelText: 'End time',
      ),
    );
  }

  TextFormField createTaskNoteField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.note),
        hintText: 'Enter notes',
        labelText: 'Notes',
      ),
    );
  }

  // TODO: Auto Suggestion
  TextFormField createTaskPeerField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.assignment_ind_outlined),
        hintText: 'Enter your reminder email or contact',
        labelText: 'Reminder contact',
      ),
    );
  }

  TextButton createSaveButton() {
    return TextButton(
      onPressed: () {
        print('Button pressed');
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
      child: const Text(
        'Add',
        style: TextStyle(fontSize: Constant.FONTSIZE_XL),
      ),
    );
  }
}
