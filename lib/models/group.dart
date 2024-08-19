import 'package:teamup/models/player.dart';

class Group {
  String name;
  List<Player> players;

  Group({required this.name, this.players = const []});
}
