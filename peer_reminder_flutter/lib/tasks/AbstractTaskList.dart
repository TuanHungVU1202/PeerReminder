import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart';
import 'package:peer_reminder_flutter/common/Util.dart';
import 'package:peer_reminder_flutter/tasks/service/ITaskService.dart';
import 'package:peer_reminder_flutter/tasks/service/TaskServiceImpl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'TaskFormPage.dart';
import 'model/Task.dart';
import 'model/TaskStatus.dart';

class AbstractTaskList extends StatefulWidget {
  const AbstractTaskList({Key? key}) : super(key: key);

  @override
  AbstractTaskListState createState() => AbstractTaskListState();
}

class AbstractTaskListState<T extends AbstractTaskList> extends State<T> {
  // Controllers
  final searchBarController = TextEditingController();

  final String largeTitle = "Task List";
  late List<String> originalTaskList;
  late List<String> filteredTaskList;
  late Future<List<Task>> tasks;
  late Task task;
  late ITaskService taskService;

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

    // FIXME: finalize this, query from DB
    originalTaskList = List<String>.generate(10000, (i) => 'Item $i');
    filteredTaskList = originalTaskList;

    // FIXME: using fake data now. Use object directly because the object should be received from YourTaskPage
    task = Util.initFakeData();

    taskService = TaskServiceImpl();
    tasks = fetchAllTask();

    // Requesting Contact permission for the first time
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // -------------------------------------------------------------------
  // UI Components
  RefreshIndicator createRefreshableBody(List<Widget> bodyWidgetList) {
    return RefreshIndicator(
        onRefresh: () => swipeDownRefresh(),
        child: createYourTaskSliverBody(bodyWidgetList));
  }

  CustomScrollView createYourTaskSliverBody(List<Widget> bodyWidgetList) {
    return CustomScrollView(slivers: bodyWidgetList);
  }

  CupertinoSliverNavigationBar createYourTasksSliverAppBar() {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(largeTitle),
    );
  }

  SliverToBoxAdapter createSearchBar() {
    return SliverToBoxAdapter(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: ClipRect(
            child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CupertinoSearchTextField(
            controller: searchBarController,
            onChanged: (value) {
              updateSearchedTaskList(value);
            },
            onSubmitted: (value) {
              updateSearchedTaskList(value);
            },
            onSuffixTap: () {
              updateSearchedTaskList('');
            },
          ),
        )),
      ),
    );
  }

  SliverList createTaskSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) return const Divider(height: 0, color: Colors.grey);

          int itemIndex = index ~/ 2;
          return createSlidableTask(itemIndex);
        },
      ),
    );
  }

  Slidable createSlidableTask(int itemIndex) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      startActionPane: ActionPane(
        motion: const DrawerMotion(),

        dismissible: DismissiblePane(confirmDismiss: () async {
          Future<bool> isConfirmed = onConfirmDeleteTask();
          return Future(() => isConfirmed);
        }, onDismissed: () {
          deleteTask(itemIndex);
        }),

        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: (context) => onPressedDelete(itemIndex),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.notifications_active_outlined,
            label: 'Notify Peer',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: createTaskContextMenu(itemIndex),
    );
  }

  CupertinoContextMenu createTaskContextMenu(int itemIndex) {
    return CupertinoContextMenu(
      actions: <Widget>[
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          isDefaultAction: true,
          trailingIcon: Icons.edit,
          child: const Text('Edit'),
        ),
      ],
      child: const Text("This is child"),
    );
  }

  InkWell createConfirmCancelButton(double width, double height) {
    return InkWell(
      child: Container(
        width: width,
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: const Center(
          child: Text(
            'Cancel',
            style: TextStyle(
                fontSize: Constant.FONTSIZE_XL, color: Colors.lightBlue),
          ),
        ),
      ),
      // false means this pop return value bool = false
      onTap: () => Navigator.of(context, rootNavigator: true).pop(false),
    );
  }

  InkWell createConfirmDeleteButton(double width, double height) {
    return InkWell(
      child: Container(
        width: width,
        // height: height*0.3,
        padding: const EdgeInsets.all(5.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: const Center(
          child: Text(
            'Delete',
            style: TextStyle(fontSize: Constant.FONTSIZE_XL, color: Colors.red),
          ),
        ),
      ),
      // true means this pop return value bool = true
      onTap: () => Navigator.of(context, rootNavigator: true).pop(true),
    );
  }

  // -------------------------------------------------------------------
  // Components' callbacks
  List<Widget> createBodyWidgetList() {
    return <Widget>[
      // Appbar
      createYourTasksSliverAppBar(),
      // Search bar
      createSearchBar(),
      // Tasks list
      createTaskSliverList(),
    ];
  }

  Future<void> swipeDownRefresh() async {
    // TODO: call get DB
    print("Swiped down");
  }

  void doNothing(BuildContext context) {
    print("abc");
  }

  Future<void> onPressedDelete(int itemIndex) async {
    Future<bool> isConfirmed = onConfirmDeleteTask();

    if (await isConfirmed) {
      deleteTask(itemIndex);
    }
  }

  Future<bool> onConfirmDeleteTask() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            elevation: 0.0,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: width,
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Column(
                    children: [
                      // Text information
                      const Text("This task will be deleted"),
                      const Divider(),
                      // Delete button
                      createConfirmDeleteButton(width, height),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Cancel button
                createConfirmCancelButton(width, height),
              ],
            ));
      },
    );
  }

  // -----------------------------
  // DB Ops
  void deleteTask(int itemIndex) {
    // TODO: Call DB
    removeTaskFromList(itemIndex);
  }

  void editTask(BuildContext context, String taskTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            TaskFormPage(taskTitle, isCreate: false),
      ),
    );
  }

  void archiveTask(Task task, int itemIndex) {
    task.taskStatus = TaskStatusEnum.archived.name;

    // Call DB
    updateTask(task);

    // TODO: after done, notify peer. Maybe cancel event as well?
  }

  void markAsDoneTask(Task task) {
    task.taskStatus = TaskStatusEnum.done.name;

    // Call DB
    updateTask(task);
  }

  void updateSearchedTaskList(String value) {
    if (value.isNotEmpty) {
      filteredTaskList = filteredTaskList
          .where(
              (element) => element.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      searchBarController.text = '';
      filteredTaskList = originalTaskList;
    }

    // To rebuild
    setState(() {});
  }

  // This should not work on simulator
  Future<void> launchDialer(String contactNumber) async {
    final callUri = Uri.parse("tel:$contactNumber");
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  Future<void> launchEmail(String email) async {
    String subject = "Request to remind!";

    // FIXME: use a body template
    String body = "Test";
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Util.encodeQueryParameters(
          <String, String>{"subject": subject, "body": body}),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  // -------------------------------------------------------------------
  // Private Utils
  Future<List<Task>> fetchAllTask() async {
    List<Task> tasks = await taskService.getAllTaskList();
    print(tasks);
    return tasks;
  }

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

  void removeTaskFromList(int itemIndex) {
    setState(() {
      filteredTaskList.removeAt(itemIndex);
    });
  }

  Future<void> updateTask(Task task) async {
    // TODO: Handle response carefully
    // The response is Date from java with startDateTime, endDateTime instead of String
    final response = await taskService.updateTask(task);

    if (response.statusCode == HttpStatus.ok) {
      var responseJson = jsonDecode(response.body);
      // task = Task.fromJson(responseJson);
      print("Updating task: ");
      print(responseJson);
    } else {
      throw Exception('TaskList::_saveTask(): Failed to update Task');
    }
  }
}
