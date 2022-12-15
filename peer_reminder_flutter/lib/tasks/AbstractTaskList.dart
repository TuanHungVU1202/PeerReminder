import 'package:flutter/material.dart';

class AbstractTaskList extends StatefulWidget {
  const AbstractTaskList({Key? key}) : super(key: key);

  @override
  AbstractTaskListState createState() => AbstractTaskListState();
}

class AbstractTaskListState<T extends AbstractTaskList> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
