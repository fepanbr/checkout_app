import 'package:flutter/material.dart';
import 'package:songaree_worktime/models/state_message.dart';
import 'package:songaree_worktime/models/today_timer.dart';
import 'package:songaree_worktime/models/week_timer.dart';

enum WorkState { beforeWork, working, afterWork }

class Work with ChangeNotifier {
  String _infoText = '';
  WorkState _state = WorkState.beforeWork;
  TodayTimer _todayTimer;
  WeekTimer _weekTimer;

  double restTime = 0.0;

  Work(this._todayTimer, this._weekTimer) {
    restTime = _weekTimer.getRestTimeToDouble();
  }

  String get getStateText => _infoText;
  WorkState get getState => _state;

  void startWork() {
    _state = WorkState.working;
    _todayTimer.start();
    _weekTimer.start();
    _infoText = StateMessage.workMsg(_todayTimer.startTime);
    notifyListeners();
  }

  void offWork() {
    _state = WorkState.afterWork;
    _todayTimer.stop();
    _weekTimer.stop();
    _weekTimer.getRestTime();
    _infoText = StateMessage.offWorkMsg(_todayTimer.getWorkTime());
    notifyListeners();
  }
}
