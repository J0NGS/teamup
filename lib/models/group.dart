import 'package:teamup/models/player.dart';

class Group {
  String name;
  List<Player> players; //trocar com player

  Group({required this.name, List<Player>? players})
      : players = players ?? [];
}
