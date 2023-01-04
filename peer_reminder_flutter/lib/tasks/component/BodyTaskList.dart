import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// Local imports
import '../provider/BodyTaskListStateProvider.dart';

class BodyTaskList extends StatelessWidget {
  const BodyTaskList({super.key});

  // FIXME: return SliverList here
  // https://medium.com/flutter-community/flutter-statemanagement-with-provider-ee251bbc5ac1
  // https://stackoverflow.com/questions/56691331/how-to-use-flutter-provider-in-a-statefulwidget
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BodyTaskListStateProvider>(
      create: (_) {
        return BodyTaskListStateProvider();
      },
    );
  }
}
