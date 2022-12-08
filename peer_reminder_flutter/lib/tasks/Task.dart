import 'package:contacts_service/contacts_service.dart';

class Task {
  late String taskName;
  late String startDate;
  late String startTime;
  late String endDate;
  late String endTime;
  late String taskNote;
  late String email;
  late String phoneNo;

  Task(this.taskName, this.startDate, this.startTime, this.endDate,
      this.endTime, this.taskNote, this.email, this.phoneNo);

  Task.fromJson(Map<String, dynamic> json)
      : taskName = json['taskName'],
        startDate = json['startDate'],
        startTime = json['startTime'],
        endDate = json['endDate'],
        endTime = json['endTime'],
        taskNote = json['taskNote'],
        email = json['email'],
        phoneNo = json['phoneNo'];

  Map<String, dynamic> toJson() => {
        'taskName': taskName,
        'startDate': startDate,
        'startTime': startTime,
        'endDate': endDate,
        'endTime': endTime,
        'taskNote': taskNote,
        'email': email,
        'phoneNo': phoneNo
      };
}
