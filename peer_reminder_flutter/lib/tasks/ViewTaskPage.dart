import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';

class ViewTaskPage extends StatefulWidget {
  final String taskTitle;
  final bool isPreview;
  const ViewTaskPage(this.taskTitle, this.isPreview, {super.key});

  @override
  State<ViewTaskPage> createState() {
    return _ViewTaskState();
  }
}

class _ViewTaskState extends State<ViewTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createYourTaskSliverBody(),
    );
  }

  // -------------------------------------------------------------------
  // UI Components
  CustomScrollView _createYourTaskSliverBody() {
    List<Widget> widgetList = <Widget>[];

    // Adding widgets
    widgetList.add(_createViewTaskSliverAppBar(widget.taskTitle));
    widgetList.add(_createViewTaskSliverList());

    return CustomScrollView(
      slivers: widgetList,
    );
  }

  CupertinoSliverNavigationBar _createViewTaskSliverAppBar(String taskTitle) {
    Widget? trailingWidget;
    // Show Edit button only if this is not a Preview widget
    if (!widget.isPreview) {
      trailingWidget = _createEditButton();
    }

    return CupertinoSliverNavigationBar(
      largeTitle: Text(taskTitle),
      trailing: trailingWidget,
    );
  }

  SliverList _createViewTaskSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) return const Divider(height: 0, color: Colors.grey);

          // int itemIndex = index ~/ 2;
          // return _createSlidableTask(itemIndex);
        },
      ),
    );
  }

  // --------------------------------------
  TextButton _createEditButton() {
    return TextButton(
      onPressed: () {
        _editTask(context, widget.taskTitle);
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
