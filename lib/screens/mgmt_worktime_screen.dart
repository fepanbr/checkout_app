import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/firebase_worktime.dart';
import 'package:songaree_worktime/models/work.dart';
import 'package:songaree_worktime/models/worktime.dart';

class MgmtWorkTimeScreen extends StatefulWidget {
  @override
  _MgmtWorkTimeScreenState createState() => _MgmtWorkTimeScreenState();
}

class _MgmtWorkTimeScreenState extends State<MgmtWorkTimeScreen> {
  List<WorkTime> weeklyWorkTimeList = [];
  getWorkLogsInThisWeek() async {
    weeklyWorkTimeList = await FirebaseWorkTime().getWorkLogsInThisWeek();
  }

  void updateWorkTime(WorkTime workTime) {}

  Future<void> getWeeklyWork() async {
    getWorkLogsInThisWeek();
    Provider.of<Work>(context, listen: false).getRestWeeklyWorkTime();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeeklyWork(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        Provider.of<Work>(context).infoMessage,
                        // Provider.of<WeeklyWork>(context).restTimeInfo,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    height: 120,
                  ),
                  FutureBuilder(
                    future: getWorkLogsInThisWeek(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          width: double.infinity,
                          height: 600,
                          child: ListView.builder(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            itemBuilder: (context, index) {
                              return MgmtCard(
                                workTime: weeklyWorkTimeList[index],
                              );
                            },
                            itemCount: 5,
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
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

  // Future<WeeklyWorkTime?> selectedTime(
  //     BuildContext context, WeeklyWorkTime workTime) async {
  //   var timeOfDayMap = workTime.toTimeOfDayMap();
  //   late TimeOfDay? pickedEndTime;
  //   var pickedStartTime = await showTimePicker(
  //     context: context,
  //     initialTime: timeOfDayMap["startTime"],
  //     builder: (context, child) {
  //       return TimePickerTheme(
  //           data: TimePickerThemeData(
  //               backgroundColor: Colors.white,
  //               dialBackgroundColor: Colors.white,
  //               dayPeriodBorderSide: BorderSide(width: 0, color: Colors.white),
  //               dayPeriodTextColor: Colors.white,
  //               hourMinuteTextColor: Colors.white,
  //               hourMinuteTextStyle:
  //                   TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
  //               dialHandColor: kPrimaryColor),
  //           child: child!);
  //     },
  //   );
  //   if (timeOfDayMap["endTime"] != null) {
  //     pickedEndTime = await showTimePicker(
  //       context: context,
  //       initialTime: timeOfDayMap["endTime"],
  //       builder: (context, child) {
  //         return TimePickerTheme(
  //             data: TimePickerThemeData(
  //                 backgroundColor: Colors.white,
  //                 dialBackgroundColor: Colors.white,
  //                 dayPeriodBorderSide:
  //                     BorderSide(width: 0, color: Colors.white),
  //                 dayPeriodTextColor: Colors.white,
  //                 hourMinuteTextColor: Colors.white,
  //                 hourMinuteTextStyle:
  //                     TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
  //                 dialHandColor: kPrimaryColor),
  //             child: child!);
  //       },
  //     );
  //   }

  //   if (pickedStartTime != null) {
  //     // return DateTime(startTime.year, startTime.month, startTime.day,
  //     //     pickedStartTime.hour, pickedStartTime.minute);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 30),
      elevation: 5,
      child: InkWell(
        onTap: () async {
          // DateTime? pickedTime = await selectedTime(
          //   context,
          //   weeklyWorkTime.startTime,
          // );
          // if (pickedTime != null) {
          //   FirebaseWorkTime().updateWorkTime(pickedTime);
          // }
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
