class WorkTime {
  DateTime? startTime;
  DateTime? endTime;
  bool haveLunch = false;
  late Duration workingTime;

  WorkTime({required this.startTime, this.endTime, required this.haveLunch}) {
    if (haveLunch == true) {
      var duration = endTime!.difference(startTime!);
      workingTime = duration.isNegative ? throw Error() : duration;
    } else {
      if (endTime != null) {
        var duration =
            endTime!.subtract(Duration(hours: 1)).difference(startTime!);
        workingTime = duration.isNegative ? throw Error() : duration;
      }
    }
  }
}
