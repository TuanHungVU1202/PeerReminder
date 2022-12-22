import '../model/Task.dart';
import 'package:http/http.dart' as http;

abstract class ITaskService {
  Task getTaskByName(String taskName);
  Task getTaskById(int taskId);
  Future<List<Task>> getAllTaskList();
  Future<List<Task>> getTaskList(int noOfTask);

  Future<http.Response> createTask(Task task);
  Future<http.Response> updateTask(Task task);

  Future<http.Response> deleteTask(Task task);
}
