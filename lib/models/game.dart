import 'package:intl/intl.dart';

class Game {
  String id;
  String teamAId;
  String teamBId;
  String eventId;
  DateTime time;

  Game({
    required this.id,
    required this.teamAId,
    required this.teamBId,
    required this.eventId,
    required this.time,
  });

  String get formattedTime {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(time);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamAId': teamAId,
      'teamBId': teamBId,
      'eventId': eventId,
      'time': time.toIso8601String(),
    };
  }

  static Game fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      teamAId: map['teamAId'],
      teamBId: map['teamBId'],
      eventId: map['eventId'],
      time: DateTime.parse(map['time']),
    );
  }
}
