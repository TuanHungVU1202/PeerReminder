import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/AbstractTaskList.dart';
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';
import 'package:peer_reminder_flutter/tasks/provider/BodyTaskListProvider.dart';
import 'package:provider/provider.dart';

// Local imports
import 'component/BodyTaskListYourTasks.dart';
import 'model/Task.dart';

class YourTaskPage extends AbstractTaskList {
  YourTaskPage({Key? key, required shouldRefresh})
      : super(key: key, shouldRefresh: shouldRefresh);

  @override
  YourTaskPageState createState() => YourTaskPageState();
}

class YourTaskPageState extends AbstractTaskListState<YourTaskPage> {
  @override
  String get largeTitle => "Your Tasks";

  @override
  Widget build(BuildContext context) {
    // FIXME: better log
    print("Rebuilding...");

    // if (widget.shouldRefresh) {
    //   refreshTaskList();
    //   widget.shouldRefresh = false;
    // }

    Scaffold mainScaffold = Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingAction(rootTaskListTitle: largeTitle),
      body: createRefreshableBody(),
    );

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        // To round the corners
        child: mainScaffold);
  }

  @override
  RefreshIndicator createRefreshableBody() {
    BodyTaskListProvider bodyTaskListProvider =
        Provider.of<BodyTaskListProvider>(context, listen: true);
    return RefreshIndicator(
        onRefresh: () => bodyTaskListProvider.fetchBodyTaskList(),
        child: createYourTaskSliverBody());
  }

  // Create and use state provider for main BodyTaskList
  @override
  Widget createBodyTaskList() {
    return const BodyTaskListYourTasks();
  }
}

////////////////////////////////////////////////////////////////////////////////
class FloatingAction extends StatelessWidget {
  const FloatingAction({super.key, required this.rootTaskListTitle});

  final String rootTaskListTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 60),
          child: FloatingActionButton(
            onPressed: () {
              _onPressedAddNewTask(context);
            },
            backgroundColor: Colors.lightBlue,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------
  // Components' callbacks
  void _onPressedAddNewTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TaskFormPage(
          task: Task.createNew("New Task"),
          isCreate: true,
          rootTaskList: YourTaskPage(shouldRefresh: true),
          rootTaskListTitle: rootTaskListTitle,
        ),
      ),
    );
  }
}
