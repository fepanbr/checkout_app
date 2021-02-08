import 'package:songaree_worktime/models/time_format.dart';
import 'package:songaree_worktime/models/timer.dart';

class WeekTimer extends Timer {
  DateTime _startTime;
  DateTime _pauseTime;
  Duration _weekWorkTime = Duration();

  static Duration _weekTotalWorkTime = Duration(hours: 40);

  @override
  TimeFormat getWorkTime() {
    // TODO: implement getWorkTime
    return TimeFormat(_weekWorkTime);
  }

  TimeFormat getRestTime() {
    return TimeFormat(_weekTotalWorkTime - _weekWorkTime);
    int hours = (_weekTotalWorkTime - _weekWorkTime).inHours;
    int minutes = (_weekTotalWorkTime - _weekWorkTime).inMinutes % 60;
    return TimeFormat(_weekWorkTime);
    print("남은 근무 시간 : $hours시간 $minutes분");
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
