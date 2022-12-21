import 'dart:core';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class Task {
  late int id;
  late String taskName;
  late String startDate;
  late String startTime;
  late String endDate;
  late String endTime;
  late String taskNote;
  late String email;
  late String phoneNo;
  late String taskCategory;
  late String taskStatus;

  Task(
      this.id,
      this.taskName,
      this.startDate,
      this.startTime,
      this.endDate,
      this.endTime,
      this.taskNote,
      this.email,
      this.phoneNo,
      this.taskCategory,
      this.taskStatus);

  Task.createNew(this.taskName);

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        taskName = json['taskName'],
        startDate = json['startDate'] ?? "",
        startTime = json['startTime'] ?? "",
        endDate = json['endDate'] ?? "",
        endTime = json['endTime'] ?? "",
        taskNote = json['taskNote'],
        email = json['email'],
        phoneNo = json['phoneNo'] ?? "",
        taskCategory = json['taskCategory'],
        taskStatus = json['taskStatus'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'taskName': taskName,
        'startDate': startDate,
        'startTime': startTime,
        'endDate': endDate,
        'endTime': endTime,
        'taskNote': taskNote,
        'email': email,
        'phoneNo': phoneNo,
        'taskCategory': taskCategory,
        'taskStatus': taskStatus,
      };
}
