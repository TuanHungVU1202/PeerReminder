import 'package:peer_reminder_flutter/tasks/model/Task.dart';
import 'package:peer_reminder_flutter/tasks/service/ITaskDBOps.dart';

class TaskDBOpsService implements TaskDBOps {
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
}
