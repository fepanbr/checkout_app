import 'dart:async';

import 'package:flutter/material.dart';
import 'package:songaree_worktime/models/firebase_worktime.dart';
import 'package:songaree_worktime/models/state_message.dart';
import 'package:songaree_worktime/models/time_format.dart';
import 'package:songaree_worktime/models/worktime.dart';

enum WorkState { beforeWork, working, afterWork }

class Work with ChangeNotifier {
  FirebaseWorkTime _firebaseWorkTime = FirebaseWorkTime();

  WorkState _state = WorkState.beforeWork;
  bool haveLunch = false;

  bool isFirst = true;
  String _infoText = '';
  double percentage = 0;

  String get getStateText => _infoText;
  WorkState get getState => _state;

  void initWork() async {
    isFirst = false;
    DateTime now = DateTime.now();
    WorkTime? workLog = await _firebaseWorkTime.getWorkLog(now);

    if (workLog == null) {
      _state = WorkState.beforeWork;
      haveLunch = false;
      Duration workingTimeInWeekly = await _firebaseWorkTime.getWeeklyWorkLog();

      percentage = workingTimeInWeekly.inMinutes / 2400 > 1
          ? 1
          : workingTimeInWeekly.inMinutes / 2400;
      notifyListeners();
    } else {
      DateTime startTime = workLog.startTime!;
      DateTime? endTime = workLog.endTime;
      Duration workingTimeInWeekly = await _firebaseWorkTime.getWeeklyWorkLog();

      TimeFormat timeFormat =
          TimeFormat(Duration(minutes: workingTimeInWeekly.inMinutes));

      percentage = workingTimeInWeekly.inMinutes / 2400 > 1
          ? 1
          : workingTimeInWeekly.inMinutes / 2400;

      if (endTime == null) {
        // 출근 후
        _infoText =
            StateMessage.workingMsg(TimeFormat(now.difference(startTime)));
        _state = WorkState.working;
        notifyListeners();
      } else {
        // 퇴근
        _state = WorkState.afterWork;
        haveLunch = false;
        _infoText = StateMessage.totalTimeInWeeklyMsg(timeFormat);
        notifyListeners();
      }
    }
  }

  void startWork() async {
    DateTime now = DateTime.now();
    _firebaseWorkTime.writeStartTime(
        WorkTime(startTime: now, endTime: null, haveLunch: false));
    _state = WorkState.working;
    _infoText = StateMessage.workMsg(now);
    notifyListeners();
  }

  void offWork() async {
    DateTime now = DateTime.now();
    DateTime? startDate = await _firebaseWorkTime.getStartDate(now);
    try {
      var workTime = await _firebaseWorkTime.writeEndTime(
          WorkTime(startTime: startDate, endTime: now, haveLunch: haveLunch));
      TimeFormat timeFormat = TimeFormat(workTime!.workingTime!);
      _infoText = StateMessage.offWorkMsg(timeFormat);
      _state = WorkState.afterWork;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void addLunch() {
    haveLunch = !haveLunch;
    notifyListeners();
  }

  void getRestWeeklyWorkTime() async {
    Duration workingTimeInWeekly = await _firebaseWorkTime.getWeeklyWorkLog();
    TimeFormat timeFormat =
        TimeFormat(Duration(minutes: 2400 - workingTimeInWeekly.inMinutes));
    print("percentage:${workingTimeInWeekly.inMinutes / 2400}");
    if (workingTimeInWeekly.inMinutes / 2400 < 1) {
      percentage = workingTimeInWeekly.inMinutes / 2400;
    } else {
      percentage = 1.0;
    }
    _infoText = StateMessage.restTimeInWeeklyMsg(timeFormat);
    notifyListeners();

    Timer timer = Timer(Duration(seconds: 3), () async {
      DateTime now = DateTime.now();
      DateTime? startTime = await _firebaseWorkTime.getStartDate(now);
      if (startTime == null) return;
      _infoText =
          StateMessage.workingMsg(TimeFormat(now.difference(startTime)));
      notifyListeners();
    });
    timer.cancel();
  }
}
