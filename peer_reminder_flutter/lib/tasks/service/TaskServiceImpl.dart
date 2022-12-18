import 'dart:convert';

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
  List<Task> getTaskList(int noOfTask) {
    // TODO: implement getTaskList
    throw UnimplementedError();
  }

  @override
  Future<http.Response> createTask(Task task) {
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
  Future<http.Response> updateTask(Task task) {
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
}
