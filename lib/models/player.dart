class Player {
  String id;
  String name;
  String position;
  int skillRating;
  int speed;
  int phase;
  int movement;
  String photoUrl;
  bool isChecked;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.skillRating,
    required this.speed,
    required this.phase,
    required this.movement,
    this.photoUrl = '',
    this.isChecked = false,
  });
}