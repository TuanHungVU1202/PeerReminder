import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/ITaskItemIcon.dart';
import 'package:peer_reminder_flutter/tasks/model/Task.dart';
import 'package:peer_reminder_flutter/tasks/model/TaskStatus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:intl/intl.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;
import 'package:peer_reminder_flutter/common/Util.dart';

import 'model/TaskCategory.dart';

class TaskFormPage extends StatefulWidget {
  final String taskFormTitle;
  const TaskFormPage(this.taskFormTitle, {super.key});

  @override
  State<TaskFormPage> createState() {
    return _TaskFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class _TaskFormState extends State<TaskFormPage> {
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
  final _taskCategoryController = TextEditingController(
      text: Util.capitalizeEnumValue(TaskCategoryEnum.home.name));
  final _taskStatusController = TextEditingController(
      text: Util.capitalizeEnumValue(TaskStatusEnum.todo.name));

  List<Contact> _contactsList = <Contact>[];
  Contact? _selectedPerson;

  @override
  void initState() {
    super.initState();

    // Set default values
    _setDefaultDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createTaskFormSliverBody(),
    );
  }

  CustomScrollView _createTaskFormSliverBody() {
    return CustomScrollView(
      slivers: <Widget>[
        _createTaskFormSliverAppBar(widget.taskFormTitle),
        // Real body
        Util.sliverToBoxAdapter(_createBodyForm()),
      ],
    );
  }

  CupertinoSliverNavigationBar _createTaskFormSliverAppBar(String title) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(title),
      trailing: _createSaveButton(),
    );
  }

  // Body
  Form _createBodyForm() {
    return Form(
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
          _createTaskCategoryField(),
          const SizedBox(height: 16.0),
          _createTaskStatusField(),
          const SizedBox(height: 16.0),
          _createTaskPeerField(),
        ],
      ),
    );
  }

  // --------------------------------------
  TextButton _createSaveButton() {
    return TextButton(
      onPressed: () {
        _saveTask();
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

  // --------------------------------------
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

  // --------------------------------------
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
        child: _createPeerSuggestColumn(contact!),
      ),
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

  Column _createPeerSuggestColumn(Contact contact) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(contact.displayName ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(contact.phones![0].value ?? ""),
      Text(contact.emails![0].value ?? "")
    ]);
  }

  // --------------------------------------
  TextFormField _createTaskCategoryField() {
    return TextFormField(
      readOnly: true,
      controller: _taskCategoryController,
      decoration: const InputDecoration(
        icon: Icon(Icons.category),
        hintText: 'Enter task category',
        labelText: 'Task Category',
        border: OutlineInputBorder(),
      ),
      onTap: () => _showTaskCategoryPicker(),
      validator: (taskCategory) {
        if (taskCategory == null || taskCategory.isEmpty) {
          return 'Task category is required';
        }
        return null;
      },
    );
  }

  void _showTaskCategoryPicker() {
    TaskItemIcon taskCategory = TaskCategory();
    List taskCategoryTwoListsWidgetAndStr =
        _getItemTwoListsWidgetAndStr(taskCategory);
    // Item at 0th is List<Widget>, 1st is List<String>
    _showItemPicker(taskCategoryTwoListsWidgetAndStr[0],
        taskCategoryTwoListsWidgetAndStr[1], _taskCategoryController);
  }

  // --------------------------------------
  TextFormField _createTaskStatusField() {
    return TextFormField(
      readOnly: true,
      controller: _taskStatusController,
      decoration: const InputDecoration(
        icon: Icon(Icons.checklist),
        hintText: 'Enter task status',
        labelText: 'Task Status',
        border: OutlineInputBorder(),
      ),
      onTap: () => _showTaskStatusPicker(),
      validator: (taskStatus) {
        if (taskStatus == null || taskStatus.isEmpty) {
          return 'Task status is required';
        }
        return null;
      },
    );
  }

  void _showTaskStatusPicker() {
    TaskItemIcon taskStatus = TaskStatus();
    List taskStatusTwoListsWidgetAndStr =
        _getItemTwoListsWidgetAndStr(taskStatus);
    // Item at 0th is List<Widget>, 1st is List<String>
    _showItemPicker(taskStatusTwoListsWidgetAndStr[0],
        taskStatusTwoListsWidgetAndStr[1], _taskStatusController);
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

  // Utils for Cupertino Picker
  List _getItemTwoListsWidgetAndStr(TaskItemIcon itemToPickObject) {
    List<String>? itemListStr = itemToPickObject.getItemListStr();
    List<Widget> itemListWidget = Util.listStrToListWidget(itemListStr!);
    return [itemListWidget, itemListStr];
  }

  void _showItemPicker(List<Widget> itemListWidget, List<String> itemListStr,
      TextEditingController textController) {
    CupertinoPicker taskCategoryPicker = _createCupertinoPickerForTextForm(
        32, itemListWidget, itemListStr, textController);

    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: taskCategoryPicker,
              ),
            ));
  }

  CupertinoPicker _createCupertinoPickerForTextForm(
      double kItemExtent,
      List<Widget> itemWidgetList,
      List<String> itemStrList,
      TextEditingController controller) {
    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: kItemExtent,
      // This is called when selected item is changed.
      onSelectedItemChanged: (int selectedItem) {
        setState(() {
          controller.text = itemStrList[selectedItem];
        });
      },
      children: itemWidgetList,
    );
  }

  // -------------------------------------------------------------------
  void _saveTask() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Adding task...')),
      // );

      Task task = Task(
        _taskNameController.text,
        _startDateController.text,
        _startTimeController.text,
        _endDateController.text,
        _endTimeController.text,
        _taskNoteController.text,
        _selectedPerson!.emails![0].value!,
        _selectedPerson!.phones![0].value!,
        _taskCategoryController.text,
        _taskStatusController.text,
      );

      var taskJson = task.toJson();
      // TODO: send parsed JSON to backend
      print(taskJson);
    }
  }
}
