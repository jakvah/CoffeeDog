import 'package:coffee_dog/leaderboard.dart';
import 'package:http/http.dart' as http;


class Repo {
  final http.Client client;

  Repo(this.client);

  Future<MyDog> fetchDog(http.Client client) async {
    return MyDog(id, name, friends, score)
  }
  Future<List<ScoreObject>> fetchLeaderBoard(http.Client client) async {
    return [ScoreObject(name, id, image, score, movement)]
  }
}
