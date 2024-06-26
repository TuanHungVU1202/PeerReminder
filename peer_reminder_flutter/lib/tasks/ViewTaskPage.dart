import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart';
import 'package:peer_reminder_flutter/common/UIConstant.dart';
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';
import 'package:peer_reminder_flutter/common/Util.dart';
import 'package:peer_reminder_flutter/tasks/provider/BodyTaskListProvider.dart';
import 'package:provider/provider.dart';

import 'AbstractTaskList.dart';
import 'model/Task.dart';

class ViewTaskPage extends StatefulWidget {
  final Task task;
  final bool isPreview;
  final bool isEnableLeading;
  final bool isEnableContact;
  final AbstractTaskList? pageToNavigate;
  final String pageToNavigateTitle;
  final bool shouldPop;

  const ViewTaskPage(
      {super.key,
      // Optional
      this.pageToNavigate,
      this.pageToNavigateTitle = "Back",
      this.shouldPop = true,
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
    // FIXME: better log
    print("Rebuild ViewTask");

    ClipRRect bodyViewTaskPage = ClipRRect(
      // To round the corners
      borderRadius: BorderRadius.circular(8.0),
      child: Scaffold(
        body: _createYourTaskSliverBody(),
      ),
    );

    // Normal cases like view task only.
    // Leading icon is need to navigate back to TaskList
    if (widget.isEnableLeading) {
      return bodyViewTaskPage;
    }

    return WillPopScope(
        onWillPop: () async {
          // Prevent pop when shouldPop == false
          // Only prevent after saveTask or updateTask.
          // Thus, use with showViewTaskPage in TaskFormPage
          return widget.shouldPop;
        },
        child: bodyViewTaskPage);
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

  // --------------------------------------
  // App Bar components
  CupertinoSliverNavigationBar _createViewTaskSliverAppBar() {
    Widget? leadingWidget;
    Widget? trailingWidget;
    // If in Preview mode, do not create Edit button
    if (!widget.isPreview) {
      trailingWidget = _createEditButton();
    }

    if (!widget.isEnableLeading && !widget.isPreview) {
      leadingWidget = _createNavigateToTaskListButton();
    }

    return CupertinoSliverNavigationBar(
      // If in Preview mode, disable Leading back icon
      automaticallyImplyLeading: widget.isEnableLeading,
      leading: leadingWidget,
      largeTitle: Center(child: Text(widget.task.taskName)),
      trailing: trailingWidget,
    );
  }

  // To navigate back directly to Root Page (YourTasks, MyTasks)
  GestureDetector _createNavigateToTaskListButton() {
    return GestureDetector(
      onTap: () => _navigateToPage(context, widget.pageToNavigate!),
      child: Row(
        children: [
          const Icon(CupertinoIcons.back),
          Text(
            widget.pageToNavigateTitle,
            style: const TextStyle(
                fontSize: Constant.kFontSizeXL, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  TextButton _createEditButton() {
    return TextButton(
      onPressed: () {
        _editTask(context, widget.task);
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      child: const Text(
        'Edit',
        style: TextStyle(fontSize: Constant.kFontSizeXL),
      ),
    );
  }

  // --------------------------------------
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
        _createListTileForSingleItem(const Icon(Icons.checklist), "Status",
            StringUtils.capitalize(widget.task.taskStatus)),
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
                  style: UIConstant.kTitleFont,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            Expanded(
              child: Text(
                subTitle,
                style: UIConstant.kSubTitleFont,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Callbacks
  void _editTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TaskFormPage(
          task: task,
          isCreate: false,
          rootTaskList: widget.pageToNavigate,
          rootTaskListTitle: widget.pageToNavigateTitle,
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, AbstractTaskList pageToNavigate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ChangeNotifierProvider<BodyTaskListProvider>(
              create: (_) => BodyTaskListProvider(), child: pageToNavigate);
        },
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////
class ViewTaskPageRoute extends CupertinoPageRoute {
  final ViewTaskPage _viewTaskPage;

  ViewTaskPageRoute(this._viewTaskPage)
      : super(builder: (BuildContext context) => _viewTaskPage);

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: _viewTaskPage);
  }
}
