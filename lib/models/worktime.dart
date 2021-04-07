class WorkTime {
  DateTime? startTime;
  DateTime? endTime;
  bool? haveLunch;
  Duration? workingTime;

  WorkTime(this.startTime, this.endTime, this.haveLunch) {
    if (haveLunch!) {
      var duration = endTime!.add(Duration(hours: 1)).difference(startTime!);
      workingTime = duration.isNegative ? throw Error() : duration;
    } else {
      var duration = endTime!.difference(startTime!);
      workingTime = duration.isNegative ? throw Error() : duration;
    }
  }
}
