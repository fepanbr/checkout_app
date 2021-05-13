import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/weekly_worktime.dart';
import 'package:songaree_worktime/models/worktime.dart';

class MgmtWorkTimeScreen extends StatefulWidget {
  @override
  _MgmtWorkTimeScreenState createState() => _MgmtWorkTimeScreenState();
}

class _MgmtWorkTimeScreenState extends State<MgmtWorkTimeScreen> {
  List<WorkTime> weeklyList = [];
  getWorkLogsInThisWeek() async {
    var weeklyWorkProvider =
        Provider.of<WeeklyWorkTime>(context, listen: false);
    weeklyWorkProvider.initFirebase();
    await weeklyWorkProvider.initWeeklyWorkTime();

    weeklyList = weeklyWorkProvider.weeklyWorkTime.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWorkLogsInThisWeek(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        Provider.of<WeeklyWorkTime>(context, listen: false)
                            .infoMessage,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    height: 120,
                  ),
                  Container(
                    width: double.infinity,
                    height: 600,
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      itemBuilder: (context, index) {
                        return MgmtCard(
                          workTime: weeklyList[index],
                        );
                      },
                      itemCount: weeklyList.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class MgmtCard extends StatelessWidget {
  const MgmtCard({
    Key? key,
    required this.workTime,
  }) : super(key: key);
  final WorkTime workTime;

  Future<WorkTime?> selectedTime(
      BuildContext context, WorkTime workTime) async {
    var timeOfDayMap = WorkTime.toTimeOfDay(workTime);
    late WorkTime result;
    late DateTime startTime;
    late DateTime endTime;
    late bool haveLunch;
    var pickedStartTime = await showTimePicker(
      context: context,
      initialTime: timeOfDayMap["startTime"]!,
      builder: (context, child) {
        return TimePickerTheme(
            data: TimePickerThemeData(
                backgroundColor: Colors.white,
                dialBackgroundColor: Colors.white,
                dayPeriodBorderSide: BorderSide(width: 0, color: Colors.white),
                dayPeriodTextColor: Colors.white,
                hourMinuteTextColor: Colors.white,
                hourMinuteTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                dialHandColor: kPrimaryColor),
            child: child!);
      },
    );
    var pickedEndTime = await showTimePicker(
      context: context,
      initialTime: timeOfDayMap["endTime"]!,
      builder: (context, child) {
        return TimePickerTheme(
            data: TimePickerThemeData(
                backgroundColor: Colors.white,
                dialBackgroundColor: Colors.white,
                dayPeriodBorderSide: BorderSide(width: 0, color: Colors.white),
                dayPeriodTextColor: Colors.white,
                hourMinuteTextColor: Colors.white,
                hourMinuteTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                dialHandColor: kPrimaryColor),
            child: child!);
      },
    );
    if (pickedStartTime != null) {
      startTime = DateTime(workTime.startTime.year, workTime.startTime.month,
          workTime.startTime.day, pickedStartTime.hour, pickedStartTime.minute);
    } else {
      startTime = workTime.startTime;
    }

    if (pickedEndTime != null) {
      endTime = DateTime(workTime.endTime!.year, workTime.endTime!.month,
          workTime.endTime!.day, pickedEndTime.hour, pickedEndTime.minute);
    } else {
      endTime = workTime.endTime!;
    }

    haveLunch = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('식사시간 포함 유무'),
            content: Text('식사시간을 근무시간에 포함하시겠어요?'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('아니요')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('네')),
            ],
          );
        });

    // TODO: 점심 유무 체크 모달 만들기
    if (pickedStartTime == null && pickedEndTime == null) {
      return null;
    } else {
      result = WorkTime(
          startTime: startTime, endTime: endTime, haveLunch: haveLunch);
      return result;
    }
  }

  updateWorkTime(BuildContext context, WorkTime workTime) async {
    var toUpdateWorkTime = await selectedTime(context, workTime);
    if (toUpdateWorkTime != null) {
      Provider.of<WeeklyWorkTime>(context, listen: false)
          .updateWorkTime(toUpdateWorkTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<WeeklyWorkTime>(context).
    return Card(
      margin: EdgeInsets.only(bottom: 30),
      elevation: 5,
      child: InkWell(
        onTap: () {
          if (workTime.startTime.isAfter(DateTime.now())) return;
          if (DateFormat("HH:mm").format(workTime.startTime) == "00:00" ||
              DateFormat("HH:mm").format(workTime.endTime!) == "00:00") return;
          updateWorkTime(context, workTime);
        },
        child: Container(
          width: 200,
          height: 80,
          child: Row(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: kBodyTextColorLight,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          workTime.startTime.day.toString(),
                          style: TextStyle(fontSize: 32, color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: kBodyTextColorLight,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        workTime.getDayOfWeekToString(),
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              '출근 :',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 20, top: 5),
                              child: Text(
                                workTime.getStartTime,
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              '퇴근 :',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 20, top: 5),
                              child: Text(
                                workTime.getEndTime,
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
