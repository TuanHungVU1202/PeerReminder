import 'dart:convert';
import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';

// Local imports
import '../model/Task.dart';
import '../model/TaskStatus.dart';
import '../service/ITaskService.dart';
import '../service/TaskServiceImpl.dart';

class BodyTaskListStateProvider with ChangeNotifier {
  // Constructor, fetch data at the beginning
  BodyTaskListStateProvider() {
    fetchBodyTaskList();
  }

  // Inject dependency
  late ITaskService taskService;

  final List<Task> _originalTaskList = [];
  late List<Task> _filteredTaskList = [];

  List<Task> get getOriginalTaskList => _originalTaskList;
  List<Task> get getFilteredTaskList => _filteredTaskList;

  Future<void> fetchBodyTaskList() async {
    taskService = TaskServiceImpl();
    List<Task> tasks = await taskService.getAllTaskList();

    for (var task in tasks) {
      _originalTaskList.add(task);
    }

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
      throw Exception('TaskList::_saveTask(): Failed to update Task');
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
}
