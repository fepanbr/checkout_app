import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:songaree_worktime/models/firebase_worktime.dart';
import 'package:songaree_worktime/models/state_message.dart';
import 'package:songaree_worktime/models/worktime.dart';

class WeeklyWorkTime with ChangeNotifier {
  int inMinutesInWeek = 2400;
  Set<WorkTime> weeklyWorkTime = Set();
  String infoMessage = '';

  late FirebaseWorkTime _firebaseWorkTime;
  StateMessage _stateMessage = StateMessage();

  initFirebase() {
    _firebaseWorkTime = FirebaseWorkTime();
  }

  Future<void> initWeeklyWorkTime() async {
    var now = DateTime.now();
    var dummyWorkTime = WorkTime.createWeeksDummyWorkTimes(now);
    var workLogsInWeeks = await _firebaseWorkTime.getWorkLogsInThisWeek();
    weeklyWorkTime = dummyWorkTime.map((item) {
      return workLogsInWeeks.firstWhere(
          (element) =>
              DateFormat("yyyyMMdd").format(element.startTime) ==
              DateFormat("yyyyMMdd").format(item.startTime),
          orElse: () => item);
    }).toSet();
    initMessage();
    notifyListeners();
  }

  Future<void> initMessage() async {
    Duration workingTimeInWeekly =
        await _firebaseWorkTime.getWeeklyWorkingTime();
    Duration(minutes: inMinutesInWeek - workingTimeInWeekly.inMinutes);
    infoMessage = _stateMessage.restTimeInWeeklyMsg(workingTimeInWeekly);
  }
}
