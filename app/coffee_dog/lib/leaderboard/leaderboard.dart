import 'package:coffee_dog/leaderboard/LeaderBoardEntry.dart';
import 'package:coffee_dog/repo/repo.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/constants.dart';
// import 'package:coffee_dog/mock_repo.dart';
import 'score.dart';

// ignore: must_be_immutable
class LeaderBoardPage extends StatefulWidget {
  final Repo repo;

  List<ScoreObject> leaderboard = [];
  LeaderBoardPage({
    Key? key,
    required this.repo,
  }) : super(key: key) {
    this.fetchLeaderBoard();
  }

  Future<List<ScoreObject>> fetchLeaderBoard() async {
    this.leaderboard = await this.repo.fetchLeaderBoard();
    return this.leaderboard;
  }

  @override
  State<StatefulWidget> createState() => _LeaderBoardState(this.leaderboard);
}

class _LeaderBoardState extends State<LeaderBoardPage> {
  List<ScoreObject> _data = [];
  ScrollController _scrollController = ScrollController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  _LeaderBoardState(List leaderboard);

  List<LeaderBoardEntry> getLeaderBoardLosers() {
    if (this._data.length < 3) {
      return [];
    }
    var losers = this._data.sublist(3);
    List<LeaderBoardEntry> rows = losers.map((e) {
      return LeaderBoardEntry(
          image: "image",
          name: e.name,
          score: e.score,
          movement: 0,
          rank: e.rank);
    }).toList();
    return rows;
  }

  List<Container> makePodium(double width, double height) {
    final String assetName = './svgs/medal.svg';

    List<Container> contList = [];
    // Have a first place
    if (this._data.length > 0) {
      contList.add(Container(
        decoration: BoxDecoration(
            color: DUTCH_WHITE,
            border: Border.all(
              color: DUTCH_WHITE,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: width / 4,
        height: height / 6,
        child: Column(children: [
          Text(
            "1",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text("${this._data.elementAt(0).name}"),
          Text("${this._data.elementAt(0).score}"),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: SvgPicture.asset(
              assetName,
              height: 30,
              width: 30,
            ),
            color: Colors.transparent,
          ),
        ]),
      ));
    }
    // Have a second place
    if (this._data.length > 1) {
      contList.insert(
          0,
          Container(
            decoration: BoxDecoration(
                color: SILVER_ISH,
                border: Border.all(
                  color: SILVER_ISH,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: width / 4,
            height: height / 8,
            child: Column(children: [
              Text(
                "2",
                style: Theme.of(context).textTheme.headline5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("${this._data.elementAt(1).name}"),
                  Text("${this._data.elementAt(1).score}"),
                ],
              ),
            ]),
          ));
    }
    // Have a third place
    if (this._data.length > 2) {
      contList.add(Container(
        decoration: BoxDecoration(
            color: BRONZE_ISH,
            border: Border.all(
              color: BRONZE_ISH,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: width / 4,
        height: height / 9,
        child: Column(children: [
          Text(
            "3",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text("${this._data.elementAt(2).name}"),
          Text("${this._data.elementAt(2).score}"),
        ]),
      ));
    }
    return contList;
  }

  replaceData() async {
    var newData = await widget.fetchLeaderBoard();
    if (mounted) {
      setState(() {
        _data = newData;
      });
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: _refreshController,
            scrollController: _scrollController,
            onRefresh: this.replaceData,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    child: Row(
                      children: makePodium(width, height),
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
                  Center(
                    child: Column(children: [
                      Padding(padding: EdgeInsets.all(10)),
                      ...getLeaderBoardLosers()
                    ]),
                  )
                ],
              ),
            )));
  }
}
