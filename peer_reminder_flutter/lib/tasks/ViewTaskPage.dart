import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart';
import 'package:peer_reminder_flutter/common/UIConstant.dart';
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';
import 'package:peer_reminder_flutter/common/Util.dart';

import 'model/Task.dart';

class ViewTaskPage extends StatefulWidget {
  final Task task;
  final bool isPreview;
  final bool isEnableLeading;
  final bool isEnableContact;
  const ViewTaskPage(
      {super.key,
      required this.task,
      required this.isEnableLeading,
      required this.isPreview,
      required this.isEnableContact});

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

    if (widget.isEnableContact) {
      widgetList.add(Util.sliverToBoxAdapter(_createDataBodyWithContact()));
    } else {
      widgetList.add(Util.sliverToBoxAdapter(_createDataBodyWithOutContact()));
    }

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
      automaticallyImplyLeading: widget.isEnableLeading,
      largeTitle: Center(child: Text(widget.task.taskName)),
      trailing: trailingWidget,
    );
  }

  Column _createDataBodyWithOutContact() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _createListTileForSingleItem(const Icon(Icons.calendar_month_outlined),
            "Start Date", widget.task.startDate),
        _createListTileForSingleItem(
            const Icon(Icons.access_time), "Start Time", widget.task.startTime),
        _createListTileForSingleItem(
            const Icon(Icons.calendar_month), "End Date", widget.task.endDate),
        _createListTileForSingleItem(const Icon(Icons.access_time_filled),
            "End Time", widget.task.endTime),
        _createListTileForSingleItem(
            const Icon(Icons.note), "Note", widget.task.taskNote),
        _createListTileForSingleItem(
            const Icon(Icons.category), "Category", widget.task.taskCategory),
        _createListTileForSingleItem(
            const Icon(Icons.checklist), "Status", widget.task.taskStatus),
        const SizedBox(height: 80),
      ],
    );
  }

  Column _createDataBodyWithContact() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _createListTileForSingleItem(const Icon(Icons.calendar_month_outlined),
            "Start Date", widget.task.startDate),
        _createListTileForSingleItem(
            const Icon(Icons.access_time), "Start Time", widget.task.startTime),
        _createListTileForSingleItem(
            const Icon(Icons.calendar_month), "End Date", widget.task.endDate),
        _createListTileForSingleItem(const Icon(Icons.access_time_filled),
            "End Time", widget.task.endTime),
        _createListTileForSingleItem(
            const Icon(Icons.note), "Note", widget.task.taskNote),
        _createListTileForSingleItem(
            const Icon(Icons.contact_mail), "Email", widget.task.email ?? ""),
        _createListTileForSingleItem(const Icon(Icons.contact_phone), "Phone",
            widget.task.phoneNo ?? ""),
        _createListTileForSingleItem(
            const Icon(Icons.category), "Category", widget.task.taskCategory),
        _createListTileForSingleItem(const Icon(Icons.checklist), "Status",
            StringUtils.capitalize(widget.task.taskStatus)),
        const SizedBox(height: 80),
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
                  style: UIConstant.titleFont,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            Expanded(
              child: Text(
                subTitle,
                style: UIConstant.subTitleFont,
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
        _editTask(context, widget.task.taskName);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      child: const Text(
        'Edit',
        style: TextStyle(fontSize: Constant.FONTSIZE_XL),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Callbacks
  void _editTask(BuildContext context, String taskTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            TaskFormPage(taskTitle, isCreate: false),
      ),
    );
  }
}
