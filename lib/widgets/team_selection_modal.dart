import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/screens/team_result_screen.dart';

class TeamSelectionModal extends StatefulWidget {
  final Group group;
  final int selectedPlayersCount;

  TeamSelectionModal({required this.group, required this.selectedPlayersCount});

  @override
  _TeamSelectionModalState createState() => _TeamSelectionModalState();
}

class _TeamSelectionModalState extends State<TeamSelectionModal> {
  final TextEditingController _teamCountController = TextEditingController();
  bool _considerSkill = true;
  bool _considerSpeed = true;
  bool _considerMovement = true;
  bool _considerPhase = true;
  bool _considerPosition = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Configurações do Sorteio',
            style: TextStyle(fontSize: 24, color: Colors.green),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _teamCountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantidade de times',
              labelStyle: TextStyle(color: Colors.green),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Considerar:',
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          CheckboxListTile(
            title: const Text('Habilidade', style: TextStyle(color: Colors.green)),
            value: _considerSkill,
            onChanged: (bool? value) {
              setState(() {
                _considerSkill = value ?? true;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
          CheckboxListTile(
            title: const Text('Velocidade', style: TextStyle(color: Colors.green)),
            value: _considerSpeed,
            onChanged: (bool? value) {
              setState(() {
                _considerSpeed = value ?? true;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
          CheckboxListTile(
            title: const Text('Movimentação', style: TextStyle(color: Colors.green)),
            value: _considerMovement,
            onChanged: (bool? value) {
              setState(() {
                _considerMovement = value ?? true;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
          CheckboxListTile(
            title: const Text('Fase', style: TextStyle(color: Colors.green)),
            value: _considerPhase,
            onChanged: (bool? value) {
              setState(() {
                _considerPhase = value ?? true;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
          CheckboxListTile(
            title: const Text('Posição', style: TextStyle(color: Colors.green)),
            value: _considerPosition,
            onChanged: (bool? value) {
              setState(() {
                _considerPosition = value ?? true;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sortTeams,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Center(
              child: Text('Sortear', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  void _sortTeams() {
    final int teamCount = int.tryParse(_teamCountController.text) ?? 0;
    if (teamCount <= 0) {
      Get.snackbar('Erro', 'Quantidade de times inválida', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final selectedPlayers = widget.group.players.where((player) => player.isChecked).toList();
    final sortedTeams = _generateTeams(selectedPlayers, teamCount);

    Get.to(() => TeamResultScreen(teams: sortedTeams));
  }

  List<List<Player>> _generateTeams(List<Player> players, int teamCount) {
    // Calcular o ratio para cada jogador
    List<num> ratios = players.map((player) {
      double denominator = (player.speed + player.movement + player.phase).toDouble();
      return denominator == 0 ? 0 : player.skillRating * denominator;
    }).toList();

    // Normalizar os ratios para criar uma probabilidade de escolha
    num sumRatios = ratios.reduce((a, b) => a + b);
    List<double> probabilities = ratios.map((ratio) => ratio / sumRatios).toList();

    // Inicializar os times
    List<List<Player>> teams = List.generate(teamCount, (_) => []);

    // Ordenar jogadores por probabilidade de escolha
    List<Player> sortedPlayers = List.from(players);
    sortedPlayers.sort((a, b) => probabilities[players.indexOf(b)].compareTo(probabilities[players.indexOf(a)]));

    // Distribuir jogadores alternando entre os de maior e menor probabilidade com uma relação mais forte
    int left = 0;
    int right = sortedPlayers.length - 1;
    while (left <= right) {
      if (left <= right) {
        Player highProbPlayer = sortedPlayers[left++];
        _addPlayerToTeam(highProbPlayer, teams);
      }
      if (left <= right) {
        Player lowProbPlayer = sortedPlayers[right--];
        _addPlayerToTeam(lowProbPlayer, teams);
      }
    }

    // Balancear posições nos times
    for (var team in teams) {
      Map<String, int> positionCount = {};
      for (var player in team) {
        positionCount[player.position] = (positionCount[player.position] ?? 0) + 1;
      }

      // Ajustar a probabilidade de escolha de jogadores com base na posição
      for (var player in team) {
        if (positionCount[player.position]! > 1) {
          probabilities[players.indexOf(player)] *= 0.9; // Diminuir a probabilidade em 10%
        }
      }
    }

    // Refinamento para equilibrar as médias dos ratios dos times
    bool improved = true;
    while (improved) {
      improved = false;
      for (int i = 0; i < teams.length; i++) {
        for (int j = i + 1; j < teams.length; j++) {
          for (var playerA in teams[i]) {
            for (var playerB in teams[j]) {
              num ratioA = ratios[players.indexOf(playerA)];
              num ratioB = ratios[players.indexOf(playerB)];
              double avgRatioTeamI = teams[i].map((p) => ratios[players.indexOf(p)]).reduce((a, b) => a + b) / teams[i].length;
              double avgRatioTeamJ = teams[j].map((p) => ratios[players.indexOf(p)]).reduce((a, b) => a + b) / teams[j].length;

              // Calcular a diferença de balanceamento antes e depois da troca
              double currentDifference = (avgRatioTeamI - avgRatioTeamJ).abs();
              double newDifference = ((avgRatioTeamI - ratioA + ratioB) - (avgRatioTeamJ - ratioB + ratioA)).abs();

              // Trocar jogadores se melhorar o balanceamento
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
    for (int i = 0; i < 10; i++) { // Realizar 10 trocas aleatórias
      int teamAIndex = Random().nextInt(teamCount);
      int teamBIndex = Random().nextInt(teamCount);
      if (teamAIndex != teamBIndex && teams[teamAIndex].isNotEmpty && teams[teamBIndex].isNotEmpty) {
        int playerAIndex = Random().nextInt(teams[teamAIndex].length);
        int playerBIndex = Random().nextInt(teams[teamBIndex].length);
        Player playerA = teams[teamAIndex][playerAIndex];
        Player playerB = teams[teamBIndex][playerBIndex];

        // Calcular a diferença de balanceamento antes e depois da troca
        num ratioA = ratios[players.indexOf(playerA)];
        num ratioB = ratios[players.indexOf(playerB)];
        double avgRatioTeamA = teams[teamAIndex].map((p) => ratios[players.indexOf(p)]).reduce((a, b) => a + b) / teams[teamAIndex].length;
        double avgRatioTeamB = teams[teamBIndex].map((p) => ratios[players.indexOf(p)]).reduce((a, b) => a + b) / teams[teamBIndex].length;
        double currentDifference = (avgRatioTeamA - avgRatioTeamB).abs();
        double newDifference = ((avgRatioTeamA - ratioA + ratioB) - (avgRatioTeamB - ratioB + ratioA)).abs();

        // Trocar jogadores se a nova diferença não desbalancear significativamente
        if (newDifference <= currentDifference * 7.0) { // Permitir uma pequena margem de desbalanceamento
          teams[teamAIndex][playerAIndex] = playerB;
          teams[teamBIndex][playerBIndex] = playerA;
        }
      }
    }

    return teams;
  }

  void _addPlayerToTeam(Player player, List<List<Player>> teams) {
    // Encontrar o time com menos jogadores (excluindo goleiros)
    List<Player> team = teams.reduce((a, b) => a.length < b.length ? a : b);

    // Verificar se o time já tem um goleiro
    bool hasGoalkeeper = team.any((p) => p.position == 'Goleiro');

    // Adicionar jogador ao time
    if (player.position == 'Goleiro' && hasGoalkeeper) {
      for (var t in teams) {
        if (!t.any((p) => p.position == 'Goleiro')) {
          t.add(player);
          return;
        }
      }
    } else {
      team.add(player);
    }
  }
}