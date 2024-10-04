class Game {
  String id;
  String teamAId;
  String teamBId;
  String eventId;

  Game({
    required this.id,
    required this.teamAId,
    required this.teamBId,
    required this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamAId': teamAId,
      'teamBId': teamBId,
      'eventId': eventId,
    };
  }

  static Game fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      teamAId: map['teamAId'],
      teamBId: map['teamBId'],
      eventId: map['eventId'],
    );
  }
}
