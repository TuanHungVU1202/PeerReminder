import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

abstract class IBodyTaskList {
  Slidable createSlidableTask(int itemIndex, BuildContext context);
  CupertinoContextMenu createTaskContextMenu(
      int itemIndex, BuildContext context);
}
