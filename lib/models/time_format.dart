class TimeFormat {
  int hours = 0;
  int minutes = 0;

  TimeFormat(Duration duration) {
    hours = duration.inHours;
    minutes = duration.inMinutes % 60;
  }
}
