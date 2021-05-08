import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:songaree_worktime/models/firebase_worktime.dart';
import 'package:songaree_worktime/models/worktime.dart';

class WeeklyWorkTime with ChangeNotifier {
  Set<WorkTime> weeklyWorkTime = Set();

  FirebaseWorkTime _firebaseWorkTime = FirebaseWorkTime();

  Future<void> initWeeklyWorkTime() async {
    var now = DateTime.now();
    var dummyWorkTime = WorkTime.createWeeksDummyWorkTimes(now);
    var workLogsInWeeks = await _firebaseWorkTime.getWorkLogsInThisWeek();
    print(workLogsInWeeks.toList());
    weeklyWorkTime = dummyWorkTime.map((item) {
      return workLogsInWeeks.firstWhere(
          (element) =>
              DateFormat("yyyyMMdd").format(element.startTime) ==
              DateFormat("yyyyMMdd").format(item.startTime),
          orElse: () => item);
    }).toSet();
    notifyListeners();
  }
}
