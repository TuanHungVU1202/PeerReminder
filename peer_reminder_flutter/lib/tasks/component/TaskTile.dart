import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/model/TaskCategory.dart';
import 'package:peer_reminder_flutter/tasks/model/TaskStatus.dart';

import '../AbstractTaskList.dart';
import '../ViewTaskPage.dart';
import '../model/Task.dart';
import 'package:peer_reminder_flutter/common/UIConstant.dart';

class TaskTile extends StatelessWidget {
  final int taskIndex;
  final Task task;
  final bool isPreviewTask;
  final bool isEnableLeading;
  final bool isEnableContact;
  final AbstractTaskList? rootTaskList;
  final String rootTaskListTitle;
  final TaskCategory taskCategory = TaskCategory();
  final TaskStatus taskStatus = TaskStatus();

  TaskTile(this.taskIndex,
      {super.key,
      this.rootTaskList,
      this.rootTaskListTitle = "Task List",
      required this.task,
      required this.isPreviewTask,
      required this.isEnableLeading,
      required this.isEnableContact});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  onTap: () => _viewTask(context, task.taskName),
                  // selectedTileColor: Colors.lightBlue,
                  title: Text(
                    task.taskName,
                    style: UIConstant.kBiggerFont,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              // Icon(taskCategory.getItemIcon(task.taskCategory)),
              SizedBox(
                width: 25,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Icon(taskCategory.getItemIcon(task.taskCategory)),
                ),
              ),
              SizedBox(
                width: 80,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Icon(taskStatus.getItemIcon(task.taskStatus)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Callbacks
  void _viewTask(BuildContext context, String taskTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Not preview => isPreview = false
        builder: (BuildContext context) => ViewTaskPage(
          task: task,
          isEnableLeading: isEnableLeading,
          isPreview: isPreviewTask,
          isEnableContact: isEnableContact,
          pageToNavigate: rootTaskList,
          pageToNavigateTitle: rootTaskListTitle,
        ),
      ),
    );
  }
}
