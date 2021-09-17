import 'package:flutter/material.dart';

class ScoreObject {
  final String name;
  final String id;
  final String image;
  final int score;
  final int movement;

  ScoreObject(this.name, this.id, this.image, this.score, this.movement);
}

class LeaderBoardPage extends StatefulWidget {
  final List<ScoreObject> data;
  LeaderBoardPage(this.data);
  @override
  State<StatefulWidget> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoardPage> {
  List<DataColumn> getDataColumns() {
    List<DataColumn> columns = [];
    widget.data.map((e) => {columns.add(DataColumn(label: Text(e.name)))});
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DataTable(
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
    );
  }
}