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
        id = "${json['id']}",
        image = "json['image']",
        score = json['score'],
        movement = 1,
        rank = json["rank"];
}
