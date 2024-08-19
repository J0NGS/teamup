class Player {
  String name;
  String position;
  int skillRating;
  int speed;
  int phase;
  int movement;
  String photoUrl; // URL da foto ou caminho para a foto local
  bool isChecked;

  Player({
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
