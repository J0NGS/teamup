class Goal {
  String id;
  String playerId;
  String teamId;
  String gameId;
  Duration time;

  Goal({
    required this.id,
    required this.playerId,
    required this.teamId,
    required this.gameId,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerId': playerId,
      'teamId': teamId,
      'gameId': gameId,
      'time': time.inMinutes.toString(), // Correct method
    };
  }

  static Goal fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      playerId: map['playerId'],
      teamId: map['teamId'],
      gameId: map['gameId'],
      time: Duration(minutes: int.parse(map['time'])), // Correct type
    );
  }
}
