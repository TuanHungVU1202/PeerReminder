import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../tasks/MyTaskPage.dart';
import '../tasks/YourTaskPage.dart';
import '../tasks/provider/BodyTaskListStateProvider.dart';

class CupertinoHomePage extends StatefulWidget {
  const CupertinoHomePage({Key? key}) : super(key: key);

  @override
  CupertinoHomePageState createState() => CupertinoHomePageState();
}

class CupertinoHomePageState extends State<CupertinoHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 1,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.tray_arrow_down), label: 'My Tasks'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.tray_arrow_up), label: 'Your Tasks'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings), label: 'Settings'),
        ],
      ),
      tabBuilder: (context, index) {
        late final CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = _createMyTasksTabView();
            break;
          case 1:
            returnValue = _createYourTasksTabView();
            break;
          case 2:
            returnValue = _createSettingsTabView();
            break;
        }
        return returnValue;
      },
    );
  }

  // -------------------------------------------------------------------
  // UI components
  // CupertinoTabView _createMyTasksTabView() {
  //   return CupertinoTabView(
  //     builder: (context) {
  //       return MyTaskPage(shouldRefresh: false);
  //     },
  //   );
  // }

  CupertinoTabView _createMyTasksTabView() {
    return CupertinoTabView(
      builder: (context) {
        return Provider<BodyTaskListStateProvider>(
            create: (_) => BodyTaskListStateProvider(),
            // we use `builder` to obtain a new `BuildContext` that has access to the provider
            builder: (context, child) {
              // No longer throws
              return MyTaskPage(shouldRefresh: false);
            });
      },
    );
  }

  // CupertinoTabView _createYourTasksTabView() {
  //   return CupertinoTabView(
  //     builder: (context) {
  //       return YourTaskPage(shouldRefresh: false);
  //     },
  //   );
  // }

  CupertinoTabView _createYourTasksTabView() {
    return CupertinoTabView(
      builder: (context) {
        return Provider<BodyTaskListStateProvider>(
            create: (_) => BodyTaskListStateProvider(),
            // we use `builder` to obtain a new `BuildContext` that has access to the provider
            builder: (context, child) {
              // No longer throws
              return YourTaskPage(shouldRefresh: false);
            });
      },
    );
  }

  CupertinoTabView _createSettingsTabView() {
    return CupertinoTabView(builder: (context) {
      return const CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Settings'),
          ),
        ],
      );
    });
  }
}
