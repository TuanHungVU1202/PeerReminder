import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/Task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:intl/intl.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;
import 'package:peer_reminder_flutter/common/Util.dart';

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
  final DateTime _selectedDate = DateTime.now();
  final TimeOfDay _selectedTime = TimeOfDay.now();

  // Controllers
  final _taskNameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _taskNoteController = TextEditingController();

  List<Contact> _contactsList = <Contact>[];
  Contact? _selectedPerson;

  @override
  Widget build(BuildContext context) {
    // Set default values
    _setDefaultDateTime();

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text('New Task'),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
        trailing: _createSaveButton(),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // List TextFormField here
              const SizedBox(height: 16.0),
              _createTaskNameField(),
              const SizedBox(height: 16.0),
              _createTaskStartDateField(),
              const SizedBox(height: 16.0),
              _createTaskStartTimeField(),
              const SizedBox(height: 16.0),
              _createTaskEndDateField(),
              const SizedBox(height: 16.0),
              _createTaskEndTimeField(),
              const SizedBox(height: 16.0),
              _createTaskNoteField(),
              const SizedBox(height: 16.0),
              _createTaskPeerField(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _createTaskNameField() {
    return TextFormField(
      controller: _taskNameController,
      decoration: const InputDecoration(
        icon: Icon(Icons.task),
        hintText: 'Enter task name',
        labelText: 'Task Name',
        border: OutlineInputBorder(),
      ),
      validator: (taskName) {
        if (taskName == null || taskName.isEmpty) {
          return 'Task name is required';
        }
        return null;
      },
    );
  }

  // --------------------------------------
  // Start Date and Time
  TextFormField _createTaskStartDateField() {
    return TextFormField(
      readOnly: true,
      controller: _startDateController,
      onTap: () => Util.selectDateForTexFormField(
          context, _startDateController, _selectedDate),
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_month_outlined),
        hintText: 'Select starting date',
        labelText: 'Start date',
        border: OutlineInputBorder(),
      ),
    );
  }

  TextFormField _createTaskStartTimeField() {
    return TextFormField(
      readOnly: true,
      controller: _startTimeController,
      onTap: () => Util.selectTimeForTexFormField(
          context, _startTimeController, _selectedTime),
      decoration: const InputDecoration(
        icon: Icon(Icons.access_time),
        hintText: 'Select starting time',
        labelText: 'Start time',
        border: OutlineInputBorder(),
      ),
    );
  }

  // --------------------------------------
  // End Date and Time
  TextFormField _createTaskEndDateField() {
    return TextFormField(
      readOnly: true,
      controller: _endDateController,
      onTap: () => Util.selectDateForTexFormField(
          context, _endDateController, _selectedDate),
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_month),
        hintText: 'Select ending date',
        labelText: 'End date',
        border: OutlineInputBorder(),
      ),
      validator: (endDateTime) {
        if (!_isEndTimeBeforeStartTime(endDateTime!)) {
          return "End time must be same or after start time";
        }
        return null;
      },
    );
  }

  TextFormField _createTaskEndTimeField() {
    return TextFormField(
      readOnly: true,
      controller: _endTimeController,
      onTap: () => Util.selectTimeForTexFormField(
          context, _endTimeController, _selectedTime),
      decoration: const InputDecoration(
        icon: Icon(Icons.access_time_filled),
        hintText: 'Select ending time',
        labelText: 'End time',
        border: OutlineInputBorder(),
      ),
    );
  }

  // --------------------------------------
  TextFormField _createTaskNoteField() {
    return TextFormField(
      controller: _taskNoteController,
      decoration: const InputDecoration(
        icon: Icon(Icons.note),
        hintText: 'Enter notes',
        labelText: 'Notes',
        border: OutlineInputBorder(),
      ),
    );
  }

  SimpleAutocompleteFormField<Contact> _createTaskPeerField() {
    return SimpleAutocompleteFormField<Contact>(
      decoration: const InputDecoration(
          icon: Icon(Icons.assignment_ind_outlined),
          hintText: 'Enter your reminder email or contact',
          labelText: 'Reminder contact',
          border: OutlineInputBorder()),
      suggestionsHeight: 200.0,
      maxSuggestions: 5,
      itemBuilder: (context, contact) => Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
            bottom: 5.0,
            left: 45,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(contact?.displayName ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(contact?.phones![0].value ?? ""),
            Text(contact?.emails![0].value ?? "")
          ])),
      onSearch: (String search) => _searchPeerContact(search),
      itemToString: (contact) => contact?.emails?[0].value ?? "",
      itemFromString: (string) {
        final matches = _contactsList.where((contact) =>
            contact.displayName?.toLowerCase() == string.toLowerCase());
        return matches.isEmpty ? null : matches.first;
      },
      onChanged: (value) => setState(() => _selectedPerson = value),
      onSaved: (value) => setState(() => _selectedPerson = value),
      validator: (contact) =>
          contact == null ? "Peer contact is required" : null,
    );
  }

  TextButton _createSaveButton() {
    return TextButton(
      onPressed: () {
        _addTask();
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      child: const Text(
        'Save',
        style: TextStyle(fontSize: constant.FONTSIZE_XL),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Private Utils
  void _setDefaultDateTime() {
    String hour = Util.getHourFromTimeOfDay(_selectedTime);
    String minute = Util.getMinuteFromTimeOfDay(_selectedTime);

    // Init values
    _startDateController.text = Util.formatDate(_selectedDate);
    _endDateController.text = Util.formatDate(_selectedDate);

    _startTimeController.text = '$hour:$minute';
    _endTimeController.text = '$hour:$minute';
  }

  Future<List<Contact>> _searchPeerContact(String search) async {
    // Check permission
    var permission = await Util.getContactPermission();

    // If no permission, return empty list
    if (permission != PermissionStatus.granted) {
      return <Contact>[];
    }
    _contactsList = await ContactsService.getContacts(query: search);

    return _contactsList
        .where((contact) =>
            contact.displayName!.toLowerCase().contains(search.toLowerCase()) ||
            contact.phones![0].value!
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            contact.emails![0].value!
                .toLowerCase()
                .contains(search.toLowerCase()))
        .toList();
  }

  // Not Before means Equals or After
  bool _isEndTimeBeforeStartTime(String endDateStr) {
    DateTime endDateTime = DateFormat(constant.DATETIME_FORMAT)
        .parse("$endDateStr ${_endTimeController.text}");
    DateTime startDateTime = DateFormat(constant.DATETIME_FORMAT)
        .parse("${_startDateController.text} ${_startTimeController.text}");

    if (endDateTime.isBefore(startDateTime)) {
      return false;
    }

    return true;
  }

  // -------------------------------------------------------------------
  void _addTask() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Adding task...')),
      // );

      Task newTask = Task(
        _taskNameController.text,
        _startDateController.text,
        _startTimeController.text,
        _endDateController.text,
        _endTimeController.text,
        _taskNoteController.text,
        _selectedPerson!.emails![0].value!,
        _selectedPerson!.phones![0].value!,
      );

      var newTaskJson = newTask.toJson();
      // TODO: send parsed JSON to backend
    }
  }
}
