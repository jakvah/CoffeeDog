import 'dart:convert';

import 'package:coffee_dog/profilePictureHandler.dart';
import 'package:coffee_dog/repo/mock_repo.dart';
import 'package:coffee_dog/repo/repo.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyDog {
  final String id;
  final String name;
  final List<String> friends;
  final int score;
  final DateTime lastCup;

  MyDog(this.id, this.name, this.friends, this.score, this.lastCup);

  MyDog.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        friends = json["friends"],
        score = json["score"],
        lastCup = DateTime.parse(json["lastCup"]);
}

// ignore: must_be_immutable
class HomeDogPage extends StatefulWidget {
  final MockRepo repo;
  final String id;
  HomeDogPage({Key? key, required this.repo, required this.id})
      : super(key: key) {
    this.fetchMyDog();
  }

  MyDog me = MyDog("id", "name", [], 0, DateTime.now());

  Future<MyDog> fetchMyDog() async {
    this.me = await repo.fetchDog(this.id);
    return me;
  }

  @override
  _HomeDogPageState createState() => _HomeDogPageState(me);
}

class _HomeDogPageState extends State<HomeDogPage> {
  final MyDog me;
  List<String> _coffeDogs;
  int _coffeCups = 0;
  String _myName = "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  _HomeDogPageState(this.me)
      : _coffeDogs = me.friends,
        _coffeCups = me.score,
        _myName = me.name;

  void _onRefresh() async {
    // monitor network fetch
    var newData = await widget.fetchMyDog();
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
      temp += " og " + this._coffeDogs.last;
    }
    if (this._coffeDogs.length == 1) {
      temp = this._coffeDogs.first;
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(body: ProfilePicPicker(repo: MockRepo()));
    return Scaffold(
        body: SmartRefresher(
      controller: this._refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: this._onRefresh,
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
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
