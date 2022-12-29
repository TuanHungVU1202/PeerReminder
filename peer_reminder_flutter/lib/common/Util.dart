import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:peer_reminder_flutter/common/Constant.dart';

import '../tasks/model/Task.dart';

class Util {
  static Future<void> selectDateForTexFormField(BuildContext context,
      TextEditingController controller, DateTime selectedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      selectedDate = picked;
      //assign the chosen date to the controller
      controller.text = formatDate(selectedDate);
    }
  }

  static Future<void> selectTimeForTexFormField(BuildContext context,
      TextEditingController controller, TimeOfDay selectedTime) async {
    TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.input);

    if (newTime == null) return;
    final hour = getHourFromTimeOfDay(newTime);
    final minute = getMinuteFromTimeOfDay(newTime);
    //assign the chosen date to the controller
    controller.text = '$hour:$minute';
  }

  static Future<PermissionStatus> getContactPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;

    if (permission == PermissionStatus.granted) {
      return permission;
    }

    final Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.contacts].request();
    return permissionStatus[Permission.contacts] ??
        PermissionStatus.permanentlyDenied;
  }

  static String getHourFromTimeOfDay(TimeOfDay timeOfDay) {
    return timeOfDay.hour.toString().padLeft(2, '0');
  }

  static String getMinuteFromTimeOfDay(TimeOfDay timeOfDay) {
    return timeOfDay.minute.toString().padLeft(2, '0');
  }

  static String formatDate(DateTime date) {
    String formattedDate = DateFormat(Constant.kDateFormat).format(date);
    return formattedDate;
  }

  static List<Widget> listStrToListWidget(List<String> listStr) {
    List<Widget> widgetList = <Widget>[];
    for (var i = 0; i < listStr.length; i++) {
      widgetList.add(Text(listStr[i]));
    }
    return widgetList;
  }

  static SliverToBoxAdapter sliverToBoxAdapter(Widget widgetToConvert) {
    return SliverToBoxAdapter(child: widgetToConvert);
  }

  static String capitalizeEnumValue(String enumStr) {
    return StringUtils.capitalize(enumStr);
  }

  static Task initFakeData() {
    Task task = Task(
      3,
      "Test task ne 123",
      "11-12-2022",
      "17:34",
      "11-12-2022",
      "17:34",
      "this is a noteeeeethis is a noteeeeethis is a noteeeeethis is a noteeeeethis is a noteeeeethis is a noteeeeethis is a noteeeeethis is a noteeeeethis is a noteeeeethis is a noteeeee",
      "anna-haro@mac.com",
      "555-522-8243",
      "Home",
      "Todo",
    );
    return task;
  }

  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  // Convert BE Date object to date and time separately
  static List<String> dateBeToDateTimeStr(String beDateStr) {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(beDateStr);
    var inputDate = DateTime.parse(parseDate.toString());

    var outputFormat = DateFormat('dd-MM-yyyy hh:mm');
    var outputDate = outputFormat.format(inputDate);

    return outputDate.split(" ");
  }

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
}
