import 'package:songaree_worktime/models/time_format.dart';
import 'package:songaree_worktime/models/timer.dart';

class WeekTimer extends Timer {
  DateTime _startTime;
  DateTime _pauseTime;
  Duration _weekWorkTime = Duration();

  static Duration _weekTotalWorkTime = Duration(hours: 40);

  @override
  TimeFormat getWorkTime() {
    return TimeFormat(_weekWorkTime);
  }

  TimeFormat getRestTime() {
    return TimeFormat(_weekTotalWorkTime - _weekWorkTime);
  }

  double getRestTimeToDouble() {
    return (_weekWorkTime.inMinutes /
        (_weekTotalWorkTime - _weekWorkTime).inMinutes);
  }

  @override
  void start() {
    _startTime = DateTime.now();
  }

  @override
  void stop() {
    _pauseTime = DateTime.now();
    _weekWorkTime = _pauseTime.difference(_startTime);
  }
}
