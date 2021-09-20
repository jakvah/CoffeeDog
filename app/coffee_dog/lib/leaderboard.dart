import 'package:coffee_dog/mock_repo.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'utils/constants.dart';

class ScoreObject {
  final String name;
  final String id;
  final String image;
  final int score;
  final int movement;
  final int rank;

  ScoreObject(
      this.name, this.id, this.image, this.score, this.movement, this.rank);

  ScoreObject.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        image = json['image'],
        score = json['score'],
        movement = json['movement'],
        rank = json["rank"];
}

// ignore: must_be_immutable
class LeaderBoardPage extends StatefulWidget {
  final MockRepo repo;

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
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  _LeaderBoardState(List leaderboard);

  List<DataRow> getDataRows() {
    List<DataRow> columns = this
        ._data
        .map((e) {
          return DataRow(cells: <DataCell>[
            DataCell(Text("${e.rank}")),
            DataCell(Text(e.name)),
            DataCell(Text("${e.score}")),
            DataCell(Text("${e.movement}")),
          ]);
        })
        .cast<DataRow>()
        .toList();
    return columns;
  }

  List<Container> makePodium(double width, double height) {
    List<Container> contList = [];
    // Have a first place
    if (this._data.length > 0) {
      contList.add(Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: SECONDARY_COLOR,
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
        ]),
      ));
    }
    // Have a second place
    if (this._data.length > 1) {
      contList.insert(
          0,
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: SECONDARY_COLOR,
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
            border: Border.all(
              color: SECONDARY_COLOR,
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
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Leaderboard"),
        ),
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: _refreshController,
            onRefresh: this.replaceData,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(20)),
                Container(
                  child: Row(
                    children: makePodium(width, height),
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ),
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('#',
                          style: TextStyle(fontStyle: FontStyle.italic)),
                    ),
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Score',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '+/- last week',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: getDataRows(),
                ),
              ],
            )));
  }
}
