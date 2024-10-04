class Goal {
  String id;
  String playerId;
  String teamId;
  String gameId;
  DateTime time;

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
      'matchId': gameId,
      'time': time.toIso8601String(),
    };
  }

  static Goal fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      playerId: map['playerId'],
      teamId: map['teamId'],
      gameId: map['matchId'],
      time: DateTime.parse(map['time']),
    );
  }
}
