import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;
import 'package:peer_reminder_flutter/common/Util.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:intl/intl.dart';

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

  // FIXME: finalize this
  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
  String? selectedLetter;
  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

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
              createTaskNameField(),
              createTaskStartDateField(),
              createTaskStartTimeField(),
              createTaskEndDateField(),
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
      ),
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
      ),
    );
  }

  // TODO: Auto Suggestion
  SimpleAutocompleteFormField<String> createTaskPeerField() {
    return SimpleAutocompleteFormField<String>(
      decoration: const InputDecoration(
        icon: Icon(Icons.assignment_ind_outlined),
        hintText: 'Enter your reminder email or contact',
        labelText: 'Reminder contact',
        // border: OutlineInputBorder()
      ),
      // suggestionsHeight: 200.0,
      maxSuggestions: 5,
      itemBuilder: (context, item) => Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
          bottom: 5.0,
          left: 45,
        ),
        child: Text(
          item!,
          style: const TextStyle(fontSize: constant.FONTSIZE_L),
        ),
      ),
      onSearch: (String search) => searchPeerContact(search),
      itemFromString: (string) => letters.singleWhere(
          (letter) => letter == string.toLowerCase(),
          orElse: () => ''),
      onChanged: (value) => setState(() => selectedLetter = value),
      onSaved: (value) => setState(() => selectedLetter = value),
      validator: (letter) => letter == null ? 'Invalid contact.' : null,
    );
  }

  // Autocomplete<String> createTestAuto() {
  //   return Autocomplete<String>(
  //     optionsBuilder: (TextEditingValue textEditingValue) {
  //       if (textEditingValue.text == '') {
  //         return const Iterable<String>.empty();
  //       }
  //       return _kOptions.where((String option) {
  //         return option.contains(textEditingValue.text.toLowerCase());
  //       });
  //     },
  //     onSelected: (String selection) {
  //       debugPrint('You just selected $selection');
  //     },
  //   );
  // }

  TextButton createSaveButton() {
    return TextButton(
      onPressed: () async {
        print('Button pressed');
        print(_startDateController.text);
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
    _startDateController.text = DateFormat.yMd().format(selectedDate);
    _endDateController.text = DateFormat.yMd().format(selectedDate);

    _startTimeController.text = '$hour:$minute';
    _endTimeController.text = '$hour:$minute';
  }

  Future<List<String>> searchPeerContact(String search) async {
    return search.isEmpty
        ? letters
        : letters
        .where((letter) => search.toLowerCase().contains(letter))
        .toList();
  }
}
