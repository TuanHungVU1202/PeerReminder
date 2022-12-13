import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';
import 'package:peer_reminder_flutter/common/Util.dart';

import 'model/Task.dart';

const _titleFont = TextStyle(fontSize: constant.FONTSIZE_XL);
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
        _createListTileForSingleItem(const Icon(Icons.calendar_month_outlined),
            "Start Date", widget._task.startDate),
        _createListTileForSingleItem(const Icon(Icons.access_time),
            "Start Time", widget._task.startTime),
        _createListTileForSingleItem(
            const Icon(Icons.calendar_month), "End Date", widget._task.endDate),
        _createListTileForSingleItem(const Icon(Icons.access_time_filled),
            "End Time", widget._task.endTime),
        _createListTileForSingleItem(
            const Icon(Icons.note), "Note", widget._task.taskNote),
        _createListTileForSingleItem(
            const Icon(Icons.contact_mail), "Email", widget._task.email ?? ""),
        _createListTileForSingleItem(const Icon(Icons.contact_phone), "Phone",
            widget._task.phoneNo ?? ""),
        _createListTileForSingleItem(
            const Icon(Icons.category), "Category", widget._task.taskCategory),
        _createListTileForSingleItem(
            const Icon(Icons.checklist), "Status", widget._task.taskStatus),
      ],
    );
  }

  Container _createListTileForSingleItem(
      Icon leadingIcon, String title, String subTitle) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leadingIcon,
            const SizedBox(width: 10),
            SizedBox(
              width: 110,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  title,
                  style: _titleFont,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            Expanded(
              child: Text(
                subTitle,
                style: _subTitleFont,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
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
