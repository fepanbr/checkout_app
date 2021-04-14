import 'package:flutter/material.dart';

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
              elevation: 5,
              child: Container(
                width: 200,
                height: 120,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('28일'),
                        Text('월'),
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
