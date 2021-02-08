class TimeFormat {
  int hours;
  int minutes;

  TimeFormat(Duration duration) {
    hours = duration.inHours;
    minutes = duration.inMinutes % 60;
  }
}
