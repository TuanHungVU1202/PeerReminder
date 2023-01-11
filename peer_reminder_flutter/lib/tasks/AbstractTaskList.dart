import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Util.dart';
import 'package:peer_reminder_flutter/tasks/component/BodyTaskListYourTasks.dart';
import 'package:peer_reminder_flutter/tasks/provider/BodyTaskListProvider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../common/Constant.dart';
import 'TaskFormPage.dart';
import 'model/Task.dart';

class AbstractTaskList extends StatefulWidget {
  AbstractTaskList({Key? key, required this.shouldRefresh}) : super(key: key);

  // To check if it should be rebuild
  bool shouldRefresh;

  @override
  AbstractTaskListState createState() => AbstractTaskListState();
}

class AbstractTaskListState<T extends AbstractTaskList> extends State<T> {
  // Controllers
  final searchBarController = TextEditingController();

  final String largeTitle = "Task List";
  late bool isReverse;

  // To make sure things are mounted
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    // Requesting Contact permission for the first time
    requestPermission();

    isReverse = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // -------------------------------------------------------------------
  // UI Components
  RefreshIndicator createRefreshableBody() {
    BodyTaskListProvider bodyTaskListProvider =
        Provider.of<BodyTaskListProvider>(context, listen: true);
    return RefreshIndicator(
        onRefresh: () => bodyTaskListProvider.fetchBodyTaskList(),
        child: createYourTaskSliverBody());
  }

  CustomScrollView createYourTaskSliverBody() {
    return CustomScrollView(slivers: createBodyWidgetList());
  }

  List<Widget> createBodyWidgetList() {
    return <Widget>[
      // Appbar
      createYourTasksSliverAppBar(),
      // Search bar
      createSearchBar(),
      // Tasks list
      createBodyTaskList(),
      Util.sliverToBoxAdapter(const SizedBox(height: 100))
    ];
  }

  CupertinoSliverNavigationBar createYourTasksSliverAppBar() {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(largeTitle),
      automaticallyImplyLeading: false,
      trailing: _createSortButton(),
    );
  }

  SliverToBoxAdapter createSearchBar() {
    BodyTaskListProvider bodyTaskListState =
        Provider.of<BodyTaskListProvider>(context, listen: true);
    return SliverToBoxAdapter(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: ClipRect(
            child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CupertinoSearchTextField(
            controller: searchBarController,
            onChanged: (value) {
              bodyTaskListState.updateSearchedTaskList(
                  value, searchBarController);
            },
            onSubmitted: (value) {
              bodyTaskListState.updateSearchedTaskList(
                  value, searchBarController);
            },
            onSuffixTap: () {
              bodyTaskListState.updateSearchedTaskList('', searchBarController);
            },
          ),
        )),
      ),
    );
  }

  // Update state for the BodyTaskList
  Widget createBodyTaskList() {
    return const BodyTaskListYourTasks();
  }

  Material _createSortButton() {
    BodyTaskListProvider bodyTaskListState =
        Provider.of<BodyTaskListProvider>(context, listen: false);
    return Material(
        child: IconButton(
      icon: const Icon(Icons.sort_by_alpha),
      tooltip: 'Sort',
      onPressed: () {
        bodyTaskListState.sortList(isReverse);
        isReverse = !isReverse;
      },
    ));
  }

  // -----------------------------
  // DB Ops
  void editTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            TaskFormPage(task: task, isCreate: false),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Private Utils

  Future<bool> requestPermission() async {
    var permission = Util.getContactPermission();

    if (await permission.isGranted) {
      return true;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Contacts Permission denied'),
                content: const Text('Please enable contacts access '
                    'permission in system settings to search for peer contacts'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('Maybe later'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: const Text('Open Settings'),
                    onPressed: () => openAppSettings(),
                  )
                ],
              ));
    }
    return true;
  }
}
