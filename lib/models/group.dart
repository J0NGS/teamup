import 'package:teamup/models/player.dart';

class Group {
  String id;
  String name;
  List<Player> players;

  Group({required this.id, required this.name, List<Player>? players})
      : players = players ?? [];
}