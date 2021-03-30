import 'package:flutter/foundation.dart';
import 'package:songaree_worktime/models/time_format.dart';
import 'package:songaree_worktime/models/timer.dart';

class TodayTimer with Timer, ChangeNotifier {
  DateTime _startTime;
  DateTime _endTime;
  final Duration _addTime = Duration(hours: 1);
  Duration _totalWorkTime = Duration();
  bool _haveLunch = false;

  DateTime get startTime => _startTime;

  bool get haveLunch => _haveLunch;

  @override
  void start() {
    _startTime = DateTime.now();
  }

  @override
  void stop() {
    _endTime = DateTime.now();
    if (_haveLunch) {
      _totalWorkTime +=
          _endTime.subtract(Duration(hours: 1)).difference(_startTime) +
              _addTime;
    } else {
      _totalWorkTime +=
          _endTime.subtract(Duration(hours: 1)).difference(_startTime);
    }

    _startTime = null;
    _endTime = null;
  }

  toggleLunch() {
    _haveLunch = !_haveLunch;
  }

  @override
  TimeFormat getWorkTime() {
    return TimeFormat(_totalWorkTime);
  }
}
