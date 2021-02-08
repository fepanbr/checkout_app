import 'package:songaree_worktime/models/time_format.dart';

class StateMessage<T> {
  static String offWorkMsg(TimeFormat timeFormat) {
    String hours = timeFormat.hours.toString().length == 1
        ? '0${timeFormat.hours}'
        : timeFormat.hours.toString();
    String minutes = timeFormat.minutes.toString().length == 1
        ? '0${timeFormat.minutes}'
        : timeFormat.minutes.toString();
    return '$hours시간 $minutes분 근무하셨습니다.';
  }

  static String workMsg(DateTime dateTime) {
    String hours = dateTime.hour.toString().length == 1
        ? '0${dateTime.hour}'
        : dateTime.hour.toString();
    String minutes = dateTime.minute.toString().length == 1
        ? '0${dateTime.minute}'
        : dateTime.minute.toString();
    return '$hours시 $minutes분에 출근하였습니다.';
  }
}
