import 'package:flutter/material.dart';

import 'ViewTaskPage.dart';
import 'model/Task.dart';
import 'package:peer_reminder_flutter/common/UIConstant.dart';

class TaskTile extends StatelessWidget {
  final int taskIndex;
  final List<String> _filteredTaskList;
  final Task task;
  final bool isPreviewTask;
  final bool isEnableLeading;

  const TaskTile(this._filteredTaskList, this.taskIndex,
      {super.key,
      required this.task,
      required this.isPreviewTask,
      required this.isEnableLeading});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(left: 10),
        child: Material(
          // Create Material widget for each ListTile
          child: ListTile(
            // TODO: pass JSON string here instead just String title
            onTap: () => _viewTask(context, _filteredTaskList[taskIndex]),
            // selectedTileColor: Colors.lightBlue,
            title: Text(
              _filteredTaskList[taskIndex],
              style: UIConstant.biggerFont,
            ),
            trailing: const Icon(Icons.home),
          ),
        ));
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
            isPreview: isPreviewTask),
      ),
    );
  }
}
