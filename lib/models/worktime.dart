class WorkTime {
  DateTime? startTime;
  DateTime? endTime;
  bool? haveLunch;
  Duration? workingTime;

  WorkTime({this.startTime, this.endTime, this.haveLunch}) {
    print(startTime);
    print(endTime);
    print(haveLunch);
    if (haveLunch == true) {
      var duration = endTime!.add(Duration(hours: 1)).difference(startTime!);
      workingTime = duration.isNegative ? throw Error() : duration;
    } else {
      if (endTime != null) {
        var duration = endTime!.difference(startTime!);
        workingTime = duration.isNegative ? throw Error() : duration;
      }
    }
  }
}
