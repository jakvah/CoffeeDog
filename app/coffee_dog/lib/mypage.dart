import 'package:coffee_dog/mock_repo.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyDog {
  final String id;
  final String name;
  final List<String> friends;
  final int score;

  MyDog(this.id, this.name, this.friends, this.score);

  MyDog.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        friends = json["friends"],
        score = json["score"];
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.repo}) : super(key: key) {
    this.fetchMyDog();
  }

  final MockRepo repo;
  MyDog me = MyDog("id", "name", [], 0);
  Future<MyDog> fetchMyDog() async {
    this.me = await repo.fetchDog();
    return me;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState(me);
}

class _MyHomePageState extends State<MyHomePage> {
  final MyDog me;
  List<String> _coffeDogs = ["Jakob", "Matias", "Stian"];
  int _coffeCups = 0;
  String _myName = "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _MyHomePageState(this.me)
      : _coffeDogs = me.friends,
        _coffeCups = me.score,
        _myName = me.name;

  void _onRefresh() async {
    // monitor network fetch
    var newData = await widget.fetchMyDog();
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        _coffeDogs = newData.friends;
        _coffeCups = newData.score;
        _myName = newData.name;
      });
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  String extractFriends() {
    String temp = "";
    if (this._coffeDogs.length > 1) {
      temp += this._coffeDogs.first;
      for (var s in this._coffeDogs.sublist(1, this._coffeDogs.length - 1)) {
        temp += ", " + s;
      }
    }
    temp += " og " + this._coffeDogs.last;
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SmartRefresher(
      controller: this._refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: this._onRefresh,
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: 'Hei, ',
              style: Theme.of(context).textTheme.headline3,
              children: <TextSpan>[
                TextSpan(
                    text: this._myName + "!",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(20)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Du har drukket totalt',
                ),
                Text(
                  '$_coffeCups',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Text("antall kopper kaffe"),
                Padding(padding: EdgeInsets.all(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text("Denne uken har du drukket: "),
                          Text(
                            '$_coffeCups',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text("antall kopper kaffe"),
                        ],
                      ),
                    ),
                    Center(
                        child: Column(
                      children: [
                        Text("Forrige uke drakk du: "),
                        Text(
                          '$_coffeCups',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text("antall kopper kaffe"),
                      ],
                    ))
                  ],
                ),
                Padding(padding: EdgeInsets.all(20)),
                Text("Venner som har pause: "),
                Text(
                  this.extractFriends(),
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
