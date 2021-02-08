import 'package:flutter/foundation.dart';
import 'package:songaree_worktime/models/time_format.dart';
import 'package:songaree_worktime/models/timer.dart';

class TodayTimer with Timer, ChangeNotifier {
  DateTime _startTime;
  DateTime _endTime;
  final Duration _addTime = Duration(hours: 1);
  Duration _totalWorkTime = Duration();

  DateTime get startTime => _startTime;

  @override
  void start() {
    _startTime = DateTime.now();
  }

  @override
  void stop() {
    _endTime = DateTime.now();
    _totalWorkTime +=
        _endTime.subtract(Duration(hours: 1)).difference(_startTime);
    _startTime = null;
    _endTime = null;
  }

  addLunchTime(bool haveLunch) {
    if (!haveLunch) return;
    _totalWorkTime += _addTime;
  }

  @override
  TimeFormat getWorkTime() {
    return TimeFormat(_totalWorkTime);
    throw UnimplementedError();
  }
}
