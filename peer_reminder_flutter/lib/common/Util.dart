import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:peer_reminder_flutter/common/Constant.dart' as constant;

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
    final hour = Util.getHourFromTimeOfDay(newTime);
    final minute = Util.getMinuteFromTimeOfDay(newTime);
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
    String formattedDate = DateFormat(constant.DATE_FORMAT).format(date);
    return formattedDate;
  }

  static List<Widget> listStrToListWidget(List<String> listStr) {
    List<Widget> widgetList = <Widget>[];
    for (var i = 0; i < listStr.length; i++) {
      widgetList.add(Text(listStr[i]));
    }
    return widgetList;
  }

  static SliverToBoxAdapter sliverToBoxAdapter(Widget widgetToConvert){
    return SliverToBoxAdapter(child: widgetToConvert);
  }

  static String capitalizeEnumValue(String enumStr) {
    return StringUtils.capitalize(enumStr);
  }
}
