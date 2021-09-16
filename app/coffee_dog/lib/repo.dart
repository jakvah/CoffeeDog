import 'package:http/http.dart' as http;

class MyDog {
  final String id;
  final String name;
  final List<String> friends;
  final int score;

  MyDog(this.id, this.name, this.friends, this.score);
}
