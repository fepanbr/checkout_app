import 'package:songaree_worktime/models/time_format.dart';

abstract class Timer {
  void start();
  void stop();
  TimeFormat getWorkTime();
}
