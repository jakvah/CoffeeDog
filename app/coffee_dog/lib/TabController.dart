import 'package:coffee_dog/mock_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'mypage.dart';
import 'utils/constants.dart';

enum TabStates { profile, leaderboard }

class CDTabController extends StatefulWidget {
  TabStates state = TabStates.profile;
  final MyHomePage home = MyHomePage(repo: MockRepo());
  final LeaderBoardPage leaderBoard = LeaderBoardPage(
    repo: MockRepo(),
  );
  State<StatefulWidget> createState() => _CDTabControllerState(state);
}

class _CDTabControllerState extends State<CDTabController> {
  TabStates _state = TabStates.profile;
  final PageController _pageController = PageController();

  _CDTabControllerState(TabStates state) : this._state = state {
    // _pageController.addListener(() {
    //   setState(() {
    //     _state = TabStates.values[_pageController.page!.toInt()];
    //   });
    // });
  }

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
    // TODO: implement build
    return Scaffold(
        backgroundColor: GREY_COLOR,
        body: Column(
          children: [
            Text("CoffeeDog",
                style: TextStyle(fontSize: 30, color: MAIN_COLOR)),
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
