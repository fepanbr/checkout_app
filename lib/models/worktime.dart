class WorkTime {
  DateTime? startTime;
  DateTime? endTime;
  bool? haveLunch;
  Duration? workingTime;

  WorkTime(this.startTime, this.endTime, this.haveLunch) {
    workingTime = haveLunch!
        ? endTime!.add(Duration(hours: 1)).difference(startTime!)
        : endTime!.difference(startTime!);
  }
}
