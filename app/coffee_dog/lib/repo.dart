import 'package:coffee_dog/leaderboard.dart';
import 'package:coffee_dog/mypage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Repo {
  final http.Client client;

  Repo(this.client);
  Future<dynamic> fetch(String url) async {
    final response = await this.client.get(Uri.parse(url));

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

  Future<MyDog> fetchDog(http.Client client) async {
    var response = await fetch("");
    return MyDog.fromJson(response);
  }

  Future<List<ScoreObject>> fetchLeaderBoard(http.Client client) async {
    var response = await fetch("");
    if (response == null) {
      return [];
    } else {
      Map<String, dynamic> json = response;
      List<ScoreObject> scoreObjects = json['scores'].map((value) {
        ScoreObject.fromJson(value);
      });
      return scoreObjects;
    }
  }
}
