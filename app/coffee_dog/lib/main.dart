import 'package:coffee_dog/mock_repo.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mypage.dart';
import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'coffebrake.dart';
import 'dart:ui';
import 'utils/constants.dart';

void main() {
  runApp(CoffeDog());
}

class Constants {
  static final Color primaryColor = Color.fromRGBO(18, 26, 28, 1);
  static final Color greyColor = Color.fromRGBO(247, 247, 249, 1);
}

class CoffeDog extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoffeeDog',
      theme: ThemeData(
        primaryColor: MAIN_COLOR,
        scaffoldBackgroundColor: GREY_COLOR,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: [
              MyHomePage(repo: MockRepo()),
              LeaderBoardPage(
                repo: MockRepo(),
              ),
              CoffeBrakePage()
            ],
          ),
        ),
      ),
    );
  }
}
