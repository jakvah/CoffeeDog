import 'package:coffee_dog/leaderboard.dart';
import 'package:coffee_dog/mypage.dart';
import 'package:flutter/material.dart';
import 'leaderboard.dart';

class MockRepo {
  Future<MyDog> fetchDog() async {
    return MyDog("123", "Kristian", ["Calle", "Jakob", "Doggern"], 69);
  }

  Future<List<ScoreObject>> fetchLeaderBoard() async {
    Map<String, dynamic> json = {
      "scores": [
        {
          "name": "Kristian",
          "id": "12345sdacsd",
          "score": 12,
          "rank": 1,
          "image": "lol.png",
          "movement": 2
        },
        {
          "name": "Jakob",
          "id": "12345sd2acsd",
          "score": 11,
          "rank": 2,
          "image": "lol.png",
          "movement": -1
        },
        {
          "name": "Matias",
          "id": "12345sd22acsd",
          "score": 1,
          "rank": 3,
          "image": "lol.png",
          "movement": 0
        }
      ]
    };

    List<ScoreObject> scoreObjects = [];
    if (json.containsKey("scores")) {
      json['scores'].asMap().forEach((_, value) {
        scoreObjects.add(ScoreObject.fromJson(value));
      });
    }
    return scoreObjects;
  }
}
