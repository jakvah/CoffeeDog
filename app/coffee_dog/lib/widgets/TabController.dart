import 'package:coffee_dog/repo/mock_repo.dart';
import 'package:coffee_dog/repo/repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../leaderboard/leaderboard.dart';
import '../mypage.dart';
import '../utils/constants.dart';

enum TabStates { profile, leaderboard }

// ignore: must_be_immutable
class CDTabController extends StatefulWidget {
  TabStates state = TabStates.profile;
  final MyHomePage home;
  final LeaderBoardPage leaderBoard;

  CDTabController({Key? key, required this.home, required this.leaderBoard})
      : super(key: key);
  State<StatefulWidget> createState() => _CDTabControllerState(state);
}

class _CDTabControllerState extends State<CDTabController> {
  TabStates _state = TabStates.profile;
  final PageController _pageController = PageController();

  _CDTabControllerState(TabStates state) : this._state = state;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var profileColor = MAIN_COLOR;
    var profileTextColor = WHITE_COLOR;
    var leaderboardColor = WHITE_COLOR;
    var leaderboardTextColor = SECONDARY_COLOR;
    if (this._state == TabStates.leaderboard) {
      profileColor = WHITE_COLOR;
      profileTextColor = SECONDARY_COLOR;
      leaderboardColor = MAIN_COLOR;
      leaderboardTextColor = WHITE_COLOR;
    }
    return Scaffold(
        backgroundColor: GREY_COLOR,
        body: Column(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
            Text("CoffeeDog",
                style: TextStyle(fontSize: 40, color: MAIN_COLOR)),
            Padding(padding: EdgeInsets.all(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => changeTab(TabStates.profile),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(profileColor)),
                    child: Text(
                      "Profile",
                      style: TextStyle(color: profileTextColor),
                    )),
                ElevatedButton(
                    onPressed: () => changeTab(TabStates.leaderboard),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(leaderboardColor)),
                    child: Text(
                      "Leaderboard",
                      style: TextStyle(color: leaderboardTextColor),
                    )),
              ],
            ),
            Padding(padding: EdgeInsets.all(5)),
            Expanded(
                flex: 1,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      changeTabState(TabStates.values[index]),
                  children: [widget.home, widget.leaderBoard],
                ))
          ],
        ));
  }

  Future<void> changeTab(TabStates state) async {
    if (mounted) {
      setState(() {
        this._state = state;
      });
      print(state.index);
      if (_pageController.hasClients) {
        _pageController.animateToPage(state.index,
            curve: Curves.ease, duration: Duration(milliseconds: 500));
      }
    }
  }

  void changeTabState(TabStates state) {
    if (mounted) {
      setState(() {
        this._state = state;
      });
    }
  }
}