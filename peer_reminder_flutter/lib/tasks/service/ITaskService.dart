import '../model/Task.dart';
import 'package:http/http.dart' as http;

abstract class ITaskService {
  Task getTaskByName(String taskName);
  Task getTaskById(int taskId);
  List<Task> getTaskList(int noOfTask);

  Future<http.Response> createTask(Task task);
  Future<http.Response> updateTask(Task task);

  // FIXME: return something else for deleteTask
  void deleteTask(Task task);
}
