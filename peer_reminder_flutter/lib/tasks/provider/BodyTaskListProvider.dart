import 'dart:convert';
import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Local imports
import '../../common/Util.dart';
import '../model/Task.dart';
import '../model/TaskStatus.dart';
import '../service/ITaskService.dart';
import '../service/TaskServiceImpl.dart';

class BodyTaskListProvider with ChangeNotifier {
  // Constructor, fetch data at the beginning
  BodyTaskListProvider() {
    fetchBodyTaskList();
  }

  // Inject dependency
  late ITaskService taskService;

  late List<Task> _originalTaskList = [];
  late List<Task> _filteredTaskList = [];

  List<Task> get getOriginalTaskList => _originalTaskList;
  List<Task> get getFilteredTaskList => _filteredTaskList;

  Future<void> fetchBodyTaskList() async {
    taskService = TaskServiceImpl();
    List<Task> tasks = await taskService.getAllTaskList();

    _originalTaskList = tasks;
    _filteredTaskList = _originalTaskList;

    notifyListeners();
  }

  void archiveTask(Task task, int itemIndex) {
    task.taskStatus = StringUtils.capitalize(TaskStatusEnum.archived.name);

    // Call DB
    updateTask(task);

    removeTaskFromList(itemIndex);
    // TODO: after done, notify peer. Maybe cancel event as well?
  }

  void markAsDoneTask(Task task) {
    task.taskStatus = StringUtils.capitalize(TaskStatusEnum.done.name);

    // Call DB
    updateTask(task);
    notifyListeners();
  }

  void updateTask(Task task) async {
    // TODO: Handle update response carefully
    // The response is Date from java with startDateTime, endDateTime instead of String
    final response = await taskService.updateTask(task);

    if (response.statusCode == HttpStatus.ok) {
      var responseJson = jsonDecode(response.body);
      // task = Task.fromJson(responseJson);
      print("Updating task: ");
      print(responseJson);
    } else {
      throw Exception(
          'BodyTaskListProvider::_saveTask(): Failed to update Task');
    }
  }

  void onPressedDelete(int itemIndex, Future<bool> isConfirmed) async {
    // Future<bool> isConfirmed = onConfirmDeleteTask();

    if (await isConfirmed) {
      deleteTask(itemIndex);
    }
  }

  void deleteTask(int itemIndex) async {
    final response = await taskService.deleteTask(_filteredTaskList[itemIndex]);

    if (response.statusCode == HttpStatus.ok) {
      // TODO: change to better log
      print("Deleted taskId: ${response.body}");
      removeTaskFromList(itemIndex);
    } else {
      throw Exception(
          'BodyTaskListProvider::deleteTask(): Failed to delete Task');
    }
  }

  // Remove from Task List
  void removeTaskFromList(int itemIndex) {
    _originalTaskList.removeAt(itemIndex);
    _filteredTaskList = _originalTaskList;
    notifyListeners();
  }

  // For Search Bar
  void updateSearchedTaskList(
      String value, TextEditingController searchBarController) {
    if (value.isNotEmpty) {
      _filteredTaskList = _filteredTaskList
          .where((element) =>
              element.taskName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      notifyListeners();
    } else {
      searchBarController.text = '';
      _filteredTaskList = _originalTaskList;
      notifyListeners();
    }
  }

  // This should not work on simulator
  Future<void> launchDialer(String contactNumber) async {
    final callUri = Uri.parse("tel:$contactNumber");
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  Future<void> launchEmail(String email) async {
    String subject = "Request to remind!";

    // FIXME: use a body template
    String body = "Test";
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Util.encodeQueryParameters(
          <String, String>{"subject": subject, "body": body}),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  void sortList(bool isReverse) {
    sortTaskListByName(_filteredTaskList, isReverse);
    notifyListeners();
  }

  void sortTaskListByName(List<Task> taskList, bool isReverse) {
    if (isReverse) {
      taskList.sort((b, a) =>
          a.taskName.toLowerCase().compareTo(b.taskName.toLowerCase()));
      return;
    }
    taskList.sort(
        (a, b) => a.taskName.toLowerCase().compareTo(b.taskName.toLowerCase()));
  }
}
