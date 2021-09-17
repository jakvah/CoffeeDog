import 'package:coffee_dog/mock_repo.dart';
import 'package:flutter/material.dart';

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

class LeaderBoardPage extends StatefulWidget {
  final MockRepo repo;
  LeaderBoardPage(this.repo);
  @override
  State<StatefulWidget> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoardPage> {
  var _data = [];
  List<DataColumn> getDataColumns() {
    List<DataColumn> columns = [];
    this._data.map((e) => {columns.add(DataColumn(label: Text(e.name)))});
    return columns;
  }

  replaceData() async {
    var newData = await widget.repo.fetchLeaderBoard();
    setState(() {
      _data = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
        onRefresh: () => this.replaceData(),
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Age',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Role',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Sarah')),
                DataCell(Text('19')),
                DataCell(Text('Student')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Janine')),
                DataCell(Text('43')),
                DataCell(Text('Professor')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('William')),
                DataCell(Text('27')),
                DataCell(Text('Associate Professor')),
              ],
            ),
          ],
        ));
  }
}
