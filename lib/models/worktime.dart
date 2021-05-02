class WorkTime {
  static Duration lunchTime = Duration(hours: 1);

  DateTime startTime;
  DateTime? endTime;
  bool haveLunch = false;
  late Duration workingTime;

  WorkTime({required this.startTime, this.endTime, required this.haveLunch}) {
    if (haveLunch == true) {
      var duration = endTime!.difference(startTime);
      workingTime = duration.isNegative ? throw Error() : duration;
    } else {
      if (endTime != null) {
        var duration =
            endTime!.subtract(Duration(hours: 1)).difference(startTime);
        workingTime = duration.isNegative ? throw Error() : duration;
      }
    }
  }

  Duration calculateTodayWokingTime() {
    if (endTime != null) {
      return haveLunch
          ? endTime!
              .subtract(Duration(hours: 1))
              .add(lunchTime)
              .difference(startTime)
          : endTime!.subtract(Duration(hours: 1)).difference(startTime);
    } else {
      return throw 'endTime is not exist';
    }
  }
}
