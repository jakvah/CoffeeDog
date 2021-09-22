import 'package:coffee_dog/repo/mock_repo.dart';
import 'package:coffee_dog/repo/repo.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mypage.dart';
import 'package:flutter/material.dart';
import 'leaderboard/leaderboard.dart';
import 'dart:ui';
import 'utils/constants.dart';
import 'widgets/TabController.dart';

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
          primaryColor: DARK_BROWN,
          scaffoldBackgroundColor: GREY_COLOR,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.openSansTextTheme(),
        ),
        home: CDTabController(
          home: MyHomePage(repo: MockRepo()),
          leaderBoard: LeaderBoardPage(
            repo: Repo(),
          ),
        ));
  }
}
