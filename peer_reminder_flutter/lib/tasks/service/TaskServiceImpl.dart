import 'package:peer_reminder_flutter/tasks/model/Task.dart';
import 'package:peer_reminder_flutter/tasks/service/ITaskService.dart';
import 'package:http/http.dart' as http;

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;

class TaskServiceImpl implements ITaskService {
  @override
  void deleteTask(Task task) {
    // TODO: implement deleteTask
  }

  @override
  Task editTask(Task task) {
    // TODO: implement editTask
    throw UnimplementedError();
  }

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
  Future<http.Response> createTask(String bodyJson) {
    return http.post(
      Uri.parse(constant.TASK_LIST_BASE),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: bodyJson,
    );
  }
}
