import '../model/Task.dart';

abstract class TaskDBOps {
  Task getTaskByName(String taskName);
  Task getTaskById(int taskId);
  List<Task> getTaskList(int noOfTask);
  Task editTask(Task task);

  // FIXME: return something else for deleteTask
  void deleteTask(Task task);
}
