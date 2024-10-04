import 'dart:math';
import 'package:get/get.dart';
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
  // Calcular o ratio para cada jogador
  List<num> ratios = players.map((player) {
    double skill = considerSkill ? player.skillRating.toDouble() : 1.0;
    double speed = considerSpeed ? player.speed.toDouble() : 1.0;
    double movement = considerMovement ? player.movement.toDouble() : 0.0;
    double phase = considerPhase ? player.phase.toDouble() : 0.0;
    double denominator = speed + movement + phase;
    return denominator == 0 ? 0 : skill * denominator;
  }).toList();

  // Normalizar os ratios para criar uma probabilidade de escolha
  num sumRatios = ratios.reduce((a, b) => a + b);
  List<double> probabilities =
      ratios.map((ratio) => ratio / sumRatios).toList();

  // Inicializar os times
  List<List<Player>> teams = List.generate(teamCount, (_) => []);

  // Ordenar jogadores por probabilidade de escolha
  List<Player> sortedPlayers = List.from(players);
  sortedPlayers.sort((a, b) => probabilities[players.indexOf(b)]
      .compareTo(probabilities[players.indexOf(a)]));

  // Distribuir jogadores de forma balanceada
  int teamIndex = 0;
  for (var player in sortedPlayers) {
    teams[teamIndex].add(player);
    teamIndex = (teamIndex + 1) % teamCount;
  }

  // Balancear posições nos times, se necessário
  if (considerPosition) {
    for (var team in teams) {
      Map<String, int> positionCount = {};
      for (var player in team) {
        positionCount[player.position.value] =
            (positionCount[player.position] ?? 0) + 1;
      }

      // Ajustar a probabilidade de escolha de jogadores com base na posição
      for (var player in team) {
        if (positionCount[player.position]! > 1) {
          probabilities[players.indexOf(player)] *=
              0.9; // Diminuir a probabilidade em 10%
        }
      }
    }
  }

  // Refinamento para equilibrar as médias dos ratios dos times
  for (int iteration = 0; iteration < 50; iteration++) {
    bool improved = false;
    for (int i = 0; i < teams.length; i++) {
      for (int j = i + 1; j < teams.length; j++) {
        for (var playerA in teams[i]) {
          for (var playerB in teams[j]) {
            // Calcular a média dos ratios antes da troca
            double avgRatioTeamI = teams[i]
                    .map((p) => ratios[players.indexOf(p)])
                    .reduce((a, b) => a + b) /
                teams[i].length;
            double avgRatioTeamJ = teams[j]
                    .map((p) => ratios[players.indexOf(p)])
                    .reduce((a, b) => a + b) /
                teams[j].length;

            // Calcular a média dos ratios após a troca
            double newAvgRatioTeamI = (avgRatioTeamI * teams[i].length -
                    ratios[players.indexOf(playerA)] +
                    ratios[players.indexOf(playerB)]) /
                teams[i].length;
            double newAvgRatioTeamJ = (avgRatioTeamJ * teams[j].length -
                    ratios[players.indexOf(playerB)] +
                    ratios[players.indexOf(playerA)]) /
                teams[j].length;

            // Calcular a diferença de média antes e depois da troca
            double currentDifference = calculateTotalDifference(teams, ratios);
            double newDifference = calculateTotalDifferenceAfterSwap(
                teams, ratios, playerA, playerB, i, j);

            // Trocar jogadores se a nova diferença for menor
            if (newDifference < currentDifference) {
              teams[i].remove(playerA);
              teams[j].remove(playerB);
              teams[i].add(playerB);
              teams[j].add(playerA);
              improved = true;
            }
          }
        }
      }
    }
    if (!improved) break;
  }

  // Garantir que todos os jogadores foram distribuídos
  for (var player in players) {
    bool assigned = teams.any((team) => team.contains(player));
    if (!assigned) {
      List<Player> team = teams.reduce((a, b) => a.length < b.length ? a : b);
      team.add(player);
    }
  }

  // Adicionar aleatoriedade controlada trocando jogadores de times diferentes
  for (int i = 0; i < 10; i++) {
    // Realizar 5 trocas aleatórias
    int teamAIndex = Random().nextInt(teamCount);
    int teamBIndex = Random().nextInt(teamCount);
    if (teamAIndex != teamBIndex &&
        teams[teamAIndex].isNotEmpty &&
        teams[teamBIndex].isNotEmpty) {
      int playerAIndex = Random().nextInt(teams[teamAIndex].length);
      int playerBIndex = Random().nextInt(teams[teamBIndex].length);
      Player playerA = teams[teamAIndex][playerAIndex];
      Player playerB = teams[teamBIndex][playerBIndex];

      // Verificar se algum dos jogadores é goleiro
      if (playerA.position == 'Goleiro' || playerB.position == 'Goleiro') {
        continue; // Pular a troca se algum dos jogadores for goleiro
      }

      // Calcular a diferença de balanceamento antes e depois da troca
      num ratioA = ratios[players.indexOf(playerA)];
      num ratioB = ratios[players.indexOf(playerB)];
      double avgRatioTeamA = teams[teamAIndex]
              .map((p) => ratios[players.indexOf(p)])
              .reduce((a, b) => a + b) /
          teams[teamAIndex].length;
      double avgRatioTeamB = teams[teamBIndex]
              .map((p) => ratios[players.indexOf(p)])
              .reduce((a, b) => a + b) /
          teams[teamBIndex].length;
      double currentDifference = (avgRatioTeamA - avgRatioTeamB).abs();
      double newDifference = ((avgRatioTeamA - ratioA + ratioB) -
              (avgRatioTeamB - ratioB + ratioA))
          .abs();

      // Trocar jogadores se a nova diferença não desbalancear significativamente
      if (newDifference <= currentDifference * 1.4) {
        // Permitir uma pequena margem de desbalanceamento
        teams[teamAIndex][playerAIndex] = playerB;
        teams[teamBIndex][playerBIndex] = playerA;
      }
    }
  }

  return teams;
}

double calculateTotalDifference(List<List<Player>> teams, List<num> ratios) {
  List<double> avgRatios = teams
      .map((team) =>
          team.map((p) => ratios[team.indexOf(p)]).reduce((a, b) => a + b) /
          team.length)
      .toList();
  double totalDifference = 0.0;
  for (int i = 0; i < avgRatios.length; i++) {
    for (int j = i + 1; j < avgRatios.length; j++) {
      totalDifference += (avgRatios[i] - avgRatios[j]).abs();
    }
  }
  return totalDifference;
}

double calculateTotalDifferenceAfterSwap(
    List<List<Player>> teams,
    List<num> ratios,
    Player playerA,
    Player playerB,
    int teamAIndex,
    int teamBIndex) {
  List<double> avgRatios = teams
      .map((team) =>
          team.map((p) => ratios[team.indexOf(p)]).reduce((a, b) => a + b) /
          team.length)
      .toList();
  avgRatios[teamAIndex] = (avgRatios[teamAIndex] * teams[teamAIndex].length -
          ratios[teams[teamAIndex].indexOf(playerA)] +
          ratios[teams[teamBIndex].indexOf(playerB)]) /
      teams[teamAIndex].length;
  avgRatios[teamBIndex] = (avgRatios[teamBIndex] * teams[teamBIndex].length -
          ratios[teams[teamBIndex].indexOf(playerB)] +
          ratios[teams[teamAIndex].indexOf(playerA)]) /
      teams[teamBIndex].length;
  double totalDifference = 0.0;
  for (int i = 0; i < avgRatios.length; i++) {
    for (int j = i + 1; j < avgRatios.length; j++) {
      totalDifference += (avgRatios[i] - avgRatios[j]).abs();
    }
  }
  return totalDifference;
}
