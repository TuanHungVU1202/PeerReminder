import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peer_reminder_flutter/tasks/TaskFormPage.dart';
import 'package:peer_reminder_flutter/tasks/ViewTaskPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Local imports
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;
import 'package:peer_reminder_flutter/common/Util.dart';

// FIXME: finalize this, query from DB
final _originalTaskList = List<String>.generate(10000, (i) => 'Item $i');
const _biggerFont = TextStyle(fontSize: constant.FONTSIZE_XL);

class YourTaskPage extends StatefulWidget {
  const YourTaskPage({super.key});

  @override
  State<YourTaskPage> createState() => _YourTaskPageState();
}

class _YourTaskPageState extends State<YourTaskPage> {
  // Controllers
  final _searchBarController = TextEditingController();

  late List<String> _filteredTaskList = _originalTaskList;

  // To make sure things are mounted
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Requesting Contact permission for the first time
    _requestPermission();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const FloatingAction(),
      body: _createYourTaskSliverBody(),
    );
  }

  // -------------------------------------------------------------------
  // UI Components
  CustomScrollView _createYourTaskSliverBody() {
    return CustomScrollView(
      slivers: <Widget>[
        // Appbar
        _createYourTasksSliverAppBar(),
        // Search bar
        _createSearchBar(),
        // Tasks list
        _createTaskSliverList(),
      ],
    );
  }

  CupertinoSliverNavigationBar _createYourTasksSliverAppBar() {
    return const CupertinoSliverNavigationBar(
      largeTitle: Text('Your Tasks'),
    );
  }

  SliverToBoxAdapter _createSearchBar() {
    return SliverToBoxAdapter(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: ClipRect(
            child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: CupertinoSearchTextField(
            controller: _searchBarController,
            onChanged: (value) {
              _updateSearchedTaskList(value);
            },
            onSubmitted: (value) {
              _updateSearchedTaskList(value);
            },
            onSuffixTap: () {
              _updateSearchedTaskList('');
            },
          ),
        )),
      ),
    );
  }

  SliverList _createTaskSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) return const Divider(height: 0, color: Colors.grey);

          int itemIndex = index ~/ 2;
          return _createSlidableTask(itemIndex);
        },
      ),
    );
  }

  Slidable _createSlidableTask(int itemIndex) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      startActionPane: ActionPane(
        motion: const DrawerMotion(),

        dismissible: DismissiblePane(confirmDismiss: () async {
          Future<bool> isConfirmed = _onConfirmDeleteTask();
          return Future(() => isConfirmed);
        }, onDismissed: () {
          _deleteTask(itemIndex);
        }),

        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: (context) => _onPressedDelete(itemIndex),
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
      child: _createTaskContextMenu(itemIndex),
    );
  }

  // TODO: create corresponding callbacks for each menu selection
  CupertinoContextMenu _createTaskContextMenu(int itemIndex) {
    return CupertinoContextMenu(
      actions: <Widget>[
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            _editTask(context, _filteredTaskList[itemIndex]);
          },
          isDefaultAction: true,
          trailingIcon: Icons.edit,
          child: const Text('Edit'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          trailingIcon: CupertinoIcons.archivebox,
          child: const Text('Archive'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          trailingIcon: Icons.done,
          child: const Text('Mark as Done'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          trailingIcon: CupertinoIcons.phone,
          child: const Text('Call peer'),
        ),
      ],
      child: TaskTile(_filteredTaskList, itemIndex),
      previewBuilder: (context, animation, child) {
        // Preview only => isPreview = true
        return ViewTaskPage(_filteredTaskList[itemIndex], true);
      },
    );
  }

  InkWell _createConfirmCancelButton(double width, double height) {
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
                fontSize: constant.FONTSIZE_XL, color: Colors.lightBlue),
          ),
        ),
      ),
      // false means this pop return value bool = false
      onTap: () => Navigator.of(context, rootNavigator: true).pop(false),
    );
  }

  InkWell _createConfirmDeleteButton(double width, double height) {
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
            style: TextStyle(fontSize: constant.FONTSIZE_XL, color: Colors.red),
          ),
        ),
      ),
      // true means this pop return value bool = true
      onTap: () => Navigator.of(context, rootNavigator: true).pop(true),
    );
  }

  // -------------------------------------------------------------------
  // Components' callbacks
  void doNothing(BuildContext context) {
    print("abc");
  }

  Future<void> _onPressedDelete(int itemIndex) async {
    Future<bool> isConfirmed = _onConfirmDeleteTask();

    if (await isConfirmed) {
      _deleteTask(itemIndex);
    }
  }

  Future<bool> _onConfirmDeleteTask() async {
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
                      _createConfirmDeleteButton(width, height),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Cancel button
                _createConfirmCancelButton(width, height),
              ],
            ));
      },
    );
  }

  void _deleteTask(int itemIndex) {
    // TODO: Call DB
    setState(() {
      _filteredTaskList.removeAt(itemIndex);
    });
  }

  void _editTask(BuildContext context, String taskTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TaskFormPage(taskTitle),
      ),
    );
  }

  void _updateSearchedTaskList(String value) {
    if (value.isNotEmpty) {
      _filteredTaskList = _filteredTaskList
          .where(
              (element) => element.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      _searchBarController.text = '';
      _filteredTaskList = _originalTaskList;
    }

    // To rebuild
    setState(() {});
  }

  // -------------------------------------------------------------------
  // Private Utils
  Future<bool> _requestPermission() async {
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

////////////////////////////////////////////////////////////////////////////////
class TaskTile extends StatelessWidget {
  final int _taskIndex;
  final List<String> _filteredTaskList;

  const TaskTile(this._filteredTaskList, this._taskIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(left: 10),
        child: Material(
          // Create Material widget for each ListTile
          child: ListTile(
            // TODO: pass JSON string here instead just String title
            onTap: () => _viewTask(context, _filteredTaskList[_taskIndex]),
            // selectedTileColor: Colors.lightBlue,
            title: Text(
              _filteredTaskList[_taskIndex],
              style: _biggerFont,
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
        builder: (BuildContext context) => ViewTaskPage(taskTitle, false),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class FloatingAction extends StatelessWidget {
  const FloatingAction({super.key});

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
        builder: (BuildContext context) => const TaskFormPage("New Task"),
      ),
    );
  }
}
