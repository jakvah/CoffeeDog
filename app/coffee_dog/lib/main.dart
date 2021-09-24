import 'package:coffee_dog/InDogging.dart';
import 'package:coffee_dog/repo/mock_repo.dart';
import 'package:coffee_dog/repo/repo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mypage.dart';
import 'package:flutter/material.dart';
import 'leaderboard/leaderboard.dart';
import 'dart:ui';
import 'utils/constants.dart';
import 'widgets/TabController.dart';

void main() {
  runApp(CoffeDog());
}

enum LoginStatus { ErrorDog, OutDogged, InDogged, CreateDog }

class LoginLocal {
  Future<bool> saveUser(int user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt("uid", user);
  }

  Future<LoginStatus> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? user = prefs.getInt("uid");
    if (user != null) {
      return LoginStatus.InDogged;
    }

    return LoginStatus.OutDogged;
  }
}

// ignore: must_be_immutable
class CoffeDog extends StatefulWidget {
  // This widget is the root of the application.
  final LoginLocal localDB = LoginLocal();
  var indogged = LoginStatus.OutDogged;

  var home = MyHomePage(repo: MockRepo());
  var leaderBoard = LeaderBoardPage(
    repo: Repo(),
  );
  CoffeDog({Key? key}) : super(key: key) {
    checkIndogging();
  }

  checkIndogging() async {
    this.indogged = await this.localDB.getUser();
  }

  @override
  State<StatefulWidget> createState() => __CoffeDogState(indogged);
}

class __CoffeDogState extends State<CoffeDog> {
  var _loginStatus;
  __CoffeDogState(this._loginStatus);

  _loginCallback(LoginStatus status) {
    if (mounted) {
      setState(() {
        _loginStatus = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("State: ${this._loginStatus}");

    var indogging = IndoggingForm(
        repo: MockRepo(),
        loginCallback: _loginCallback,
        loginStatus: widget.indogged);
    Widget frontPage = widget.home;
    if (this._loginStatus == LoginStatus.OutDogged ||
        this._loginStatus == LoginStatus.CreateDog) {
      frontPage = indogging;
    }
    return MaterialApp(
        title: 'CoffeeDog',
        theme: ThemeData(
          primaryColor: DARK_BROWN,
          scaffoldBackgroundColor: GREY_COLOR,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.openSansTextTheme(),
        ),
        home:
            CDTabController(home: frontPage, leaderBoard: widget.leaderBoard));
  }
}
