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
  String groupId;

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
    required this.groupId,
  });

  // Método para converter um mapa em um objeto Player
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      position: map['position'] ?? '',
      skillRating: map['skillRating'] ?? 0,
      speed: map['speed'] ?? 0,
      phase: map['phase'] ?? 0,
      movement: map['movement'] ?? 0,
      photoUrl: map['photoUrl'] ?? '',
      isChecked: map['isChecked'] ?? false,
      groupId: map['groupId'] ?? '',
    );
  }

  // Método para converter um objeto Player em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'skillRating': skillRating,
      'speed': speed,
      'phase': phase,
      'movement': movement,
      'photoUrl': photoUrl,
      'isChecked': isChecked,
      'groupId': groupId,
    };
  }

}