import 'player.dart';

class Team {
  final List<Player> players;
  final double maxRating;
  final double averageRating;

  Team({
    required this.players,
    required this.maxRating,
    required this.averageRating,
  });
}
