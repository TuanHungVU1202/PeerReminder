import 'package:flutter/material.dart';
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
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  // Controllers
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();

  List<Contact> contactsList = <Contact>[];
  Contact? selectedPerson;

  @override
  Widget build(BuildContext context) {
    // Set default values
    setDefaultDateTime();

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
              const SizedBox(height: 16.0),
              createTaskNameField(),
              const SizedBox(height: 16.0),
              createTaskStartDateField(),
              const SizedBox(height: 16.0),
              createTaskStartTimeField(),
              const SizedBox(height: 16.0),
              createTaskEndDateField(),
              const SizedBox(height: 16.0),
              createTaskEndTimeField(),
              const SizedBox(height: 16.0),
              createTaskNoteField(),
              const SizedBox(height: 16.0),
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
  TextFormField createTaskStartDateField() {
    return TextFormField(
      readOnly: true,
      controller: _startDateController,
      onTap: () => Util.selectDateForTexFormField(
          context, _startDateController, selectedDate),
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_month_outlined),
        hintText: 'Select starting date',
        labelText: 'Start date',
        border: OutlineInputBorder(),
      ),
    );
  }

  TextFormField createTaskStartTimeField() {
    return TextFormField(
      readOnly: true,
      controller: _startTimeController,
      onTap: () => Util.selectTimeForTexFormField(
          context, _startTimeController, selectedTime),
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
  TextFormField createTaskEndDateField() {
    return TextFormField(
      readOnly: true,
      controller: _endDateController,
      onTap: () => Util.selectDateForTexFormField(
          context, _endDateController, selectedDate),
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_month),
        hintText: 'Select ending date',
        labelText: 'End date',
        border: OutlineInputBorder(),
      ),
      validator: (endDateTime) {
        if (!isEndTimeBeforeStartTime(endDateTime!)){
          return "End time must be same or after start time";
        }
        return null;
      },
    );
  }

  TextFormField createTaskEndTimeField() {
    return TextFormField(
      readOnly: true,
      controller: _endTimeController,
      onTap: () => Util.selectTimeForTexFormField(
          context, _endTimeController, selectedTime),
      decoration: const InputDecoration(
        icon: Icon(Icons.access_time_filled),
        hintText: 'Select ending time',
        labelText: 'End time',
        border: OutlineInputBorder(),
      ),
    );
  }

  // --------------------------------------
  TextFormField createTaskNoteField() {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.note),
        hintText: 'Enter notes',
        labelText: 'Notes',
        border: OutlineInputBorder(),
      ),
    );
  }

  SimpleAutocompleteFormField<Contact> createTaskPeerField() {
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
      onSearch: (String search) => searchPeerContact(search),
      itemFromString: (string) {
        final matches = contactsList.where((contact) =>
            contact.displayName?.toLowerCase() == string.toLowerCase());
        return matches.isEmpty ? null : matches.first;
      },
      onChanged: (value) => setState(() => selectedPerson = value),
      onSaved: (value) => setState(() => selectedPerson = value),
      validator: (contact) =>
          contact == null ? "Peer contact is required" : null,
    );
  }

  TextButton createSaveButton() {
    return TextButton(
      onPressed: () {
        addTask();
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
      child: const Text(
        'Add',
        style: TextStyle(fontSize: constant.FONTSIZE_XL),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Private Utils
  void setDefaultDateTime() {
    String hour = Util.getHourFromTimeOfDay(selectedTime);
    String minute = Util.getMinuteFromTimeOfDay(selectedTime);

    // Init values
    _startDateController.text = Util.formatDate(selectedDate);
    _endDateController.text = Util.formatDate(selectedDate);

    _startTimeController.text = '$hour:$minute';
    _endTimeController.text = '$hour:$minute';
  }

  Future<List<Contact>> searchPeerContact(String search) async {
    // Check permission
    var permission = await Util.getContactPermission();

    // If no permission, return empty list
    if (permission != PermissionStatus.granted) {
      return <Contact>[];
    }
    contactsList = await ContactsService.getContacts(query: search);

    return contactsList
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
  bool isEndTimeBeforeStartTime(String endDateStr){
    DateTime endDateTime = DateFormat(constant.DATETIME_FORMAT).parse("$endDateStr ${_endTimeController.text}");
    DateTime startDateTime = DateFormat(constant.DATETIME_FORMAT).parse("${_startDateController.text} ${_startTimeController.text}");

    if (endDateTime.isBefore(startDateTime)){
      return false;
    }

    return true;
  }

  // -------------------------------------------------------------------
  void addTask(){
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adding task...')),
      );
    }
  }
}
