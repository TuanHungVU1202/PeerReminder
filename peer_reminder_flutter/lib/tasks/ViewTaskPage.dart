import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';
import 'package:peer_reminder_flutter/common/Util.dart';

import 'model/Task.dart';

const _titleFont = TextStyle(fontSize: constant.FONTSIZE_XXL);
const _subTitleFont = TextStyle(fontSize: constant.FONTSIZE_XL);

class ViewTaskPage extends StatefulWidget {
  final Task _task;
  final bool isPreview;
  const ViewTaskPage(this._task, this.isPreview, {super.key});

  @override
  State<ViewTaskPage> createState() {
    return _ViewTaskState();
  }
}

class _ViewTaskState extends State<ViewTaskPage> {
  @override
  Widget build(BuildContext context) {
    // To round the corners
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Scaffold(
        body: _createYourTaskSliverBody(),
      ),
    );
  }

  // -------------------------------------------------------------------
  // UI Components
  CustomScrollView _createYourTaskSliverBody() {
    List<Widget> widgetList = <Widget>[];

    // Adding widgets
    widgetList.add(_createViewTaskSliverAppBar());
    widgetList.add(Util.sliverToBoxAdapter(_createDataBody()));

    return CustomScrollView(
      slivers: widgetList,
    );
  }

  CupertinoSliverNavigationBar _createViewTaskSliverAppBar() {
    Widget? trailingWidget;
    // If in Preview mode, do not create Edit button
    if (!widget.isPreview) {
      trailingWidget = _createEditButton();
    }

    return CupertinoSliverNavigationBar(
      // If in Preview mode, disable Leading back icon
      automaticallyImplyLeading: !widget.isPreview,
      largeTitle: Center(child: Text(widget._task.taskName)),
      trailing: trailingWidget,
    );
  }

  Column _createDataBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _createListTileForSingleItem("Task Name", widget._task.taskName),
        _createListTileForSingleItem("Start Date", widget._task.startDate),
        _createListTileForSingleItem("Start Time", widget._task.startTime),
        _createListTileForSingleItem("End Date", widget._task.endDate),
        _createListTileForSingleItem("End Time", widget._task.endTime),
        _createListTileForSingleItem("Note", widget._task.taskNote),
        _createListTileForSingleItem("Email", widget._task.email ?? ""),
        _createListTileForSingleItem("Phone", widget._task.phoneNo ?? ""),
        _createListTileForSingleItem(
            "Task Category", widget._task.taskCategory),
        _createListTileForSingleItem("Task Status", widget._task.taskStatus),
      ],
    );
  }

  ListTile _createListTileForSingleItem(String title, String subTitle) {
    return ListTile(
        title: Text(title, style: _titleFont),
        trailing: Text(subTitle, style: _subTitleFont));
  }

  // --------------------------------------
  TextButton _createEditButton() {
    return TextButton(
      onPressed: () {
        _editTask(context, widget._task.taskName);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      child: const Text(
        'Edit',
        style: TextStyle(fontSize: constant.FONTSIZE_XL),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Callbacks
  void _editTask(BuildContext context, String taskTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TaskFormPage(taskTitle),
      ),
    );
  }
}
