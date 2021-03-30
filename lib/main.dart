import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/today_timer.dart';
import 'package:songaree_worktime/models/week_timer.dart';
import 'package:songaree_worktime/models/work.dart';
import 'package:songaree_worktime/screens/home_screen.dart';
import 'package:songaree_worktime/theme.dart';

final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Work(TodayTimer(), WeekTimer()),
        child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('firebase load fail'),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                title: '송아리당뇨 출근앱',
                theme: themeData(context),
                debugShowCheckedModeBanner: false,
                home: MyHomePage(),
              );
            }
            return CircularProgressIndicator();
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '메인',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '근무시간관리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '연차관리',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
