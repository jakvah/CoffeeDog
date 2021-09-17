import 'package:coffee_dog/mock_repo.dart';

import 'mypage.dart';
import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'coffebrake.dart';

void main() {
  runApp(CoffeDog());
}

class CoffeDog extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoffeeDog',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        backgroundColor: const Color(0xFF212121),
        accentColor: Colors.white,
        accentIconTheme: IconThemeData(color: Colors.black),
        dividerColor: Colors.black12,
      ),
      darkTheme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              MyHomePage(
                title: "Min Profil",
                repo: MockRepo(),
              ),
              LeaderBoardPage(MockRepo()),
              CoffeBrakePage()
            ],
          ),
        ),
      ),
    );
  }
}
