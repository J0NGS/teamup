import 'player.dart';

class TeamDto {
  final List<Player> players;
  final double maxRating;
  final double averageRating;

  TeamDto({
    required this.players,
    required this.maxRating,
    required this.averageRating,
  });
}
