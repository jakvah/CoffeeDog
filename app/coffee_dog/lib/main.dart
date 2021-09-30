import 'package:coffee_dog/InDogging.dart';
import 'package:coffee_dog/repo/mock_repo.dart';
import 'package:coffee_dog/repo/repo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mypage.dart';
import 'package:flutter/material.dart';
import 'leaderboard/leaderboard.dart';
import 'utils/constants.dart';
import 'widgets/TabController.dart';

void main() {
  runApp(CoffeDog());
}

enum LoginStatus { ErrorDog, OutDogged, InDogged, CreateDog }

class LoginLocal {
  LoginLocal() {
    WidgetsFlutterBinding.ensureInitialized();
  }
  Future<bool> saveUser(int user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt("uid", user);
  }

  Future<LoginStatus> getLocalDoggingStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? user = prefs.getInt("uid");
    if (user != null) {
      return LoginStatus.InDogged;
    }

    return LoginStatus.OutDogged;
  }

  Future<int> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? user = prefs.getInt("uid");
    if (user != null) {
      return user;
    }

    return -1;
  }
}

// ignore: must_be_immutable
class CoffeDog extends StatefulWidget {
  // This widget is the root of the application.
  final LoginLocal localDB = LoginLocal();
  var id = -1;
  var indogged = LoginStatus.OutDogged;

  CoffeDog({Key? key}) : super(key: key) {
    checkIndogging();
  }

  checkIndogging() async {
    this.indogged = await this.localDB.getLocalDoggingStatus();
    if (this.indogged == LoginStatus.InDogged) {
      this.id = await this.localDB.getUser();
    }
  }

  @override
  State<StatefulWidget> createState() => __CoffeDogState(indogged, id);
}

class __CoffeDogState extends State<CoffeDog> {
  var _loginStatus;
  var _id;
  __CoffeDogState(this._loginStatus, this._id);

  _loginCallback(LoginStatus status) {
    if (mounted) {
      setState(() {
        _loginStatus = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var leaderBoard = LeaderBoardPage(
      repo: Repo(),
    );

    Widget frontPage;
    if (this._loginStatus == LoginStatus.OutDogged ||
        this._loginStatus == LoginStatus.CreateDog) {
      frontPage = IndoggingForm(
          repo: MockRepo(),
          loginCallback: _loginCallback,
          loginStatus: this._loginStatus);
      ;
    } else {
      frontPage = HomeDogPage(
        repo: MockRepo(),
        id: this._id.toString(),
      );
    }
    return MaterialApp(
        title: 'CoffeeDog',
        theme: ThemeData(
          primaryColor: DARK_BROWN,
          scaffoldBackgroundColor: GREY_COLOR,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.openSansTextTheme(),
        ),
        home: CDTabController(home: frontPage, leaderBoard: leaderBoard));
  }
}
