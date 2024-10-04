import 'dart:convert';

class Team {
  String id;
  List<String> players;
  String eventId;

  Team({required this.id, required this.players, required this.eventId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'players': jsonEncode(players), // Converte a lista para uma string JSON
      'eventId': eventId,
    };
  }

  static Team fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      players: List<String>.from(jsonDecode(
          map['players'])), // Converte a string JSON de volta para uma lista
      eventId: map['eventId'],
    );
  }
}
