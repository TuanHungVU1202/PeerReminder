import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:peer_reminder_flutter/common/Util.dart';
import 'package:peer_reminder_flutter/tasks/model/Task.dart';
import 'package:peer_reminder_flutter/tasks/service/ITaskService.dart';
import 'package:http/http.dart' as http;

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart';

class TaskServiceImpl implements ITaskService {
  @override
  Task getTaskById(int taskId) {
    // TODO: implement getTaskById
    throw UnimplementedError();
  }

  @override
  Task getTaskByName(String taskName) {
    // TODO: implement getTaskByName
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> getAllTaskList() async {
    final response = await http.get(Uri.parse(Constant.TASK_LIST_BASE));

    List<List<String>> startDateTimeList = [];
    List<List<String>> endDateTimeList = [];

    Iterable taskList = json.decode(response.body);

    // Parsing and adding startDate, startTime to intermediate list
    for (var element in taskList) {
      String startDateTimeBE = element['startDateTime'];
      startDateTimeList.add(_parseStartDateTime(startDateTimeBE));
    }

    // Parsing and adding endDate, endTime to intermediate list
    for (var element in taskList) {
      String endDateTimeBE = element['endDateTime'];
      endDateTimeList.add(_parseStartDateTime(endDateTimeBE));
    }

    List<Task> tasks =
        List<Task>.from(taskList.map((model) => Task.fromJson(model)));

    // Early fail
    if (tasks.length != startDateTimeList.length ||
        tasks.length != endDateTimeList.length ||
        startDateTimeList.length != endDateTimeList.length) {
      return [];
    }

    // Replacing startDate, startTime, endDate, endTime
    for (var i = 0; i < tasks.length; i++) {
      Task task = tasks[i];

      task.startDate = startDateTimeList[i][0];
      task.startTime = startDateTimeList[i][1];

      task.endDate = endDateTimeList[i][0];
      task.endTime = endDateTimeList[i][1];
    }

    return tasks;
  }

  @override
  Future<List<Task>> getTaskList(int noOfTask) async {
    // TODO: implement getTaskList
    throw UnimplementedError();
  }

  @override
  Future<http.Response> createTask(Task task) async {
    String bodyJson = jsonEncode(task.toJson());
    return http.post(
      Uri.parse(Constant.TASK_LIST_BASE),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: bodyJson,
    );
  }

  @override
  Future<http.Response> updateTask(Task task) async {
    int id = task.id;
    String bodyJson = jsonEncode(task.toJson());
    return http.put(
      Uri.parse("${Constant.TASK_LIST_BASE}/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: bodyJson,
    );
  }

  @override
  void deleteTask(Task task) {
    // TODO: implement deleteTask
  }

  // -------------------------------------------------------------------
  // Private utils
  List<String> _parseStartDateTime(String startDateTimeBE) {
    return Util.dateBeToDateTimeStr(startDateTimeBE);
  }

  List<String> _parseEndDateTime(String endDateTimeBE) {
    return Util.dateBeToDateTimeStr(endDateTimeBE);
  }
}
