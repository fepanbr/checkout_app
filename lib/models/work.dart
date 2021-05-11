import 'dart:async';

import 'package:flutter/material.dart';
import 'package:songaree_worktime/models/firebase_worktime.dart';
import 'package:songaree_worktime/models/state_message.dart';
import 'package:songaree_worktime/models/worktime.dart';

enum WorkState { beforeWork, working, afterWork }

class Work with ChangeNotifier {
  static const int FRIDAY = 5;

  FirebaseWorkTime _firebaseWorkTime = FirebaseWorkTime();
  StateMessage _stateMessage = StateMessage();

  WorkState _state = WorkState.beforeWork;
  bool haveLunch = false;
  double percentage = 0;
  String infoMessage = '';
  List<WorkTime> weeklyWorkTime = [];

  WorkState get getState => _state;

  Future<void> initWork() async {
    print('initWork');
    DateTime now = DateTime.now();
    WorkTime? workLog = await _firebaseWorkTime.getWorkLog(now);
    Duration workingTimeInWeekly =
        await _firebaseWorkTime.getWeeklyWorkingTime();
    _getPercentage(workingTimeInWeekly);

    // 출근 전
    if (workLog == null) {
      _state = WorkState.beforeWork;
      haveLunch = false;
      notifyListeners();
    } else {
      // 출근 후
      if (workLog.getWorkState == WorkState.working) {
        if (now.weekday == FRIDAY) {
          infoMessage =
              _stateMessage.workOffTimeInFriday(workLog, workingTimeInWeekly);
        } else {
          infoMessage = _stateMessage.workingMsg(workLog);
        }
        haveLunch = false;
        _state = WorkState.working;
        notifyListeners();
      } else {
        // 퇴근
        _state = WorkState.afterWork;
        haveLunch = false;
        infoMessage = _stateMessage
            .totalTimeInWeeklyMsg(Duration(minutes: workLog.workingTime!));
        notifyListeners();
      }
    }
  }

  void startWork() async {
    DateTime now = DateTime.now();
    _firebaseWorkTime.writeStartTime(
        WorkTime(startTime: now, endTime: null, haveLunch: false));
    _state = WorkState.working;
    infoMessage = _stateMessage.workMsg(now);
    notifyListeners();
  }

  void offWork() async {
    DateTime now = DateTime.now();
    WorkTime? workTime = await _firebaseWorkTime.getStartTime(now);
    if (workTime == null) throw 'not found startTime';
    try {
      var todayWorkTime = WorkTime(
          startTime: workTime.startTime, endTime: now, haveLunch: haveLunch);
      await _firebaseWorkTime.writeEndTime(todayWorkTime);
      infoMessage = _stateMessage
          .offWorkMsg(Duration(minutes: todayWorkTime.workingTime!));
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
    Duration workingTimeInWeekly =
        await _firebaseWorkTime.getWeeklyWorkingTime();
    _getPercentage(workingTimeInWeekly);
    infoMessage = _stateMessage.restTimeInWeeklyMsg(workingTimeInWeekly);
    notifyListeners();
  }

  void _getPercentage(Duration duration) {
    if (duration.inMinutes / 2400 < 1) {
      percentage = duration.inMinutes / 2400;
    } else {
      percentage = 1.0;
    }
  }
}
