import 'package:teamup/models/player.dart';

class Group {
  String id;
  String name;
  List<Player> players;
  List<String> matchIds; // Adicionando a lista de IDs de partidas

  Group({
    required this.id,
    required this.name,
    List<Player>? players,
    List<String>? matchIds,
  })  : players = players ?? [],
        matchIds = matchIds ?? [];
}