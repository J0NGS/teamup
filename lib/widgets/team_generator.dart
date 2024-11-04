import 'dart:math';
import 'package:teamup/models/player.dart';

List<List<Player>> generateTeams(
  List<Player> players,
  int teamCount,
  bool considerSkill,
  bool considerSpeed,
  bool considerMovement,
  bool considerPhase,
  bool considerPosition,
) {
  // Função para calcular o rating de cada jogador com base nos atributos considerados
  num calculatePlayerRating(Player player) {
    double skill = considerSkill ? player.skillRating.toDouble() : 1.0;
    double speed = considerSpeed ? player.speed.toDouble() : 1.0;
    double movement = considerMovement ? player.movement.toDouble() : 1.0;
    double phase = considerPhase ? player.phase.toDouble() : 1.0;

    return skill * speed * movement * phase;
  }

  // Ordena jogadores com base no rating
  players.sort(
      (a, b) => calculatePlayerRating(b).compareTo(calculatePlayerRating(a)));

  // Inicializa os times
  List<List<Player>> teams = List.generate(teamCount, (_) => []);

  // Distribui jogadores balanceando com base no rating
  int teamIndex = 0;
  for (var player in players) {
    teams[teamIndex].add(player);
    teamIndex = (teamIndex + 1) % teamCount;
  }

  // Ajuste para posicionamento se necessário
  if (considerPosition) {
    for (var team in teams) {
      Map<String, int> positionCount = {};

      // Penalizar repetição de posições, mas sem remover jogadores
      for (var player in team) {
        positionCount[player.position] =
            (positionCount[player.position] ?? 0) + 1;
      }

      // Ajustar a penalidade nas chances de escolha com base na posição repetida
      for (var player in team) {
        if (positionCount[player.position]! > 1 &&
            player.position != 'Goleiro') {
          int penalty = positionCount[player.position]! - 1;
          player.skillRating = (player.skillRating * pow(0.9, penalty))
              .toInt(); // Penaliza em 10% por repetição        }
        }

        // Trata o caso de goleiros
        int goalkeeperCount = team.where((p) => p.position == 'Goleiro').length;
        if (goalkeeperCount > 1) {
          for (int i = 1; i < goalkeeperCount; i++) {
            Player goalie = team.firstWhere((p) => p.position == 'Goleiro');
            team.remove(goalie);
            teams[(teamIndex + 1) % teamCount].add(goalie);
          }
        }
      }
    }

    // Adiciona pequenas trocas para introduzir aleatoriedade, considerando notas próximas
    Random random = Random();
    for (int i = 0; i < 2; i++) {
      int teamAIndex = random.nextInt(teamCount);
      int teamBIndex = random.nextInt(teamCount);

      if (teamAIndex != teamBIndex &&
          teams[teamAIndex].isNotEmpty &&
          teams[teamBIndex].isNotEmpty) {
        int playerAIndex = random.nextInt(teams[teamAIndex].length);
        int playerBIndex = random.nextInt(teams[teamBIndex].length);

        Player playerA = teams[teamAIndex][playerAIndex];
        Player playerB = teams[teamBIndex][playerBIndex];

        // Verifica se a troca é entre jogadores de notas próximas e se não afeta goleiros
        num ratingDifference =
            (calculatePlayerRating(playerA) - calculatePlayerRating(playerB))
                .abs();
        if (ratingDifference <=
                10 && // Limite de diferença permitido para troca
            playerA.position != 'Goleiro' &&
            playerB.position != 'Goleiro') {
          teams[teamAIndex][playerAIndex] = playerB;
          teams[teamBIndex][playerBIndex] = playerA;
        }
      }
    }
  }
  return teams;
}
