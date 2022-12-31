import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/cupertino.dart';

import '../tasks/model/Task.dart';
import 'Util.dart';

class UIUtil {
  static Widget wrapWithAnimatedBuilder({
    required Animation<Offset> animation,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => FractionalTranslation(
        translation: animation.value,
        child: child,
      ),
    );
  }

  static Event buildEventFromTask(Task task, {Recurrence? recurrence}) {
    return Event(
      title: task.taskName,
      description: task.taskNote,
      // location: 'Flutter app',
      startDate: Util.combineDateTime(task.startDate, task.startTime),
      endDate: Util.combineDateTime(task.endDate, task.endTime),
      allDay: false,
      iosParams: const IOSParams(
        reminder: Duration(minutes: 30),
        // url: "http://example.com",
      ),
      androidParams: const AndroidParams(),
      recurrence: recurrence,
    );
  }
}
