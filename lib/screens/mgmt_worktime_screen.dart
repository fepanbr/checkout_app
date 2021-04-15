import 'package:flutter/material.dart';
import 'package:songaree_worktime/constants.dart';

class MgmtWorkTimeScreen extends StatefulWidget {
  @override
  _MgmtWorkTimeScreenState createState() => _MgmtWorkTimeScreenState();
}

class _MgmtWorkTimeScreenState extends State<MgmtWorkTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20, right: 20, top: 100),
        itemBuilder: (context, i) {
          if (i != 0) {
            return Card(
              margin: EdgeInsets.only(bottom: 30),
              elevation: 5,
              child: Container(
                width: 200,
                height: 80,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: kBodyTextColorLight,
                                width: 3,
                              ),
                              // bottom: BorderSide(
                              //   color: kBodyTextColorLight,
                              //   width: 3,
                              // ),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    '28',
                                    style: TextStyle(
                                      fontSize: 32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          width: 100,
                          height: 40,
                        ),
                        Container(
                          width: 100,
                          height: 40,
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
                            child: Text('월',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w300)),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [Text('출근 : 00:00')],
                        ),
                        Row(
                          children: [Text('출근 : 00:00')],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
                child: Container(
              child: Text(
                '이번주 남은 근무 시간: 23시간 59분',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.only(bottom: 30),
            ));
          }
        },
        itemCount: 6,
      ),
    );
  }
}
