import 'package:coffee_dog/leaderboard.dart';
import 'package:coffee_dog/mypage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Repo {
  Future<dynamic> fetch(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  // Future<MyDog> fetchDog() async {
  //   var response = await fetch("");
  //   return MyDog.fromJson(response);
  // }

  Future<List<ScoreObject>> fetchLeaderBoard() async {
    var response =
        await fetch("http://jakvah.pythonanywhere.com/get_leaderboard");
    if (response == null) {
      return [];
    } else {
      List<ScoreObject> scoreObjects = [];
      if (response.containsKey("scores")) {
        response['scores'].asMap().forEach((_, value) {
          scoreObjects.add(ScoreObject.fromJson(value));
        });
      }
      return scoreObjects;
    }
  }
}
