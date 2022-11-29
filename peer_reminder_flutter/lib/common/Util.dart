import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      controller.text = DateFormat.yMd().format(selectedDate);
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

  static String getHourFromTimeOfDay(TimeOfDay timeOfDay) {
    return timeOfDay.hour.toString().padLeft(2, '0');
  }

  static String getMinuteFromTimeOfDay(TimeOfDay timeOfDay) {
    return timeOfDay.minute.toString().padLeft(2, '0');
  }
}
