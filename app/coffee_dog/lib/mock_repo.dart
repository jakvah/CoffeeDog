import 'package:coffee_dog/leaderboard.dart';
import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'package:http/http.dart' as http;

class MockRepo {
  Future<List<ScoreObject>> fetchLeaderBoard(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ScoreObject(name, id, image, score, movement)
          .fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
