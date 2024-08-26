import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/screens/team_result_screen.dart';

class TeamSelectionModal extends StatefulWidget {
  final Group group;  // Objeto grupo contendo jogadores
  final int selectedPlayersCount;  // Quantidade de jogadores selecionados

  TeamSelectionModal({required this.group, required this.selectedPlayersCount});

  @override
  _TeamSelectionModalState createState() => _TeamSelectionModalState();
}

class _TeamSelectionModalState extends State<TeamSelectionModal> {
  final TextEditingController _teamCountController = TextEditingController();  // Controlador do campo de quantidade de times
  bool _considerSpeed = true;  // Considerar a velocidade
  bool _considerMovement = true;  // Considerar a movimentação
  bool _considerPhase = true;  // Considerar a fase
  bool _considerPosition = true;  // Considerar a posição

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Configurações do Sorteio',
            style: TextStyle(fontSize: 24, color: Colors.green),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _teamCountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
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
          SizedBox(height: 20),
          Text(
            'Considerar:',
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          CheckboxListTile(
            title: Text('Velocidade', style: TextStyle(color: Colors.green)),
            value: _considerSpeed,
            onChanged: (bool? value) {
              setState(() {
                _considerSpeed = value ?? false;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
          CheckboxListTile(
            title: Text('Movimentação', style: TextStyle(color: Colors.green)),
            value: _considerMovement,
            onChanged: (bool? value) {
              setState(() {
                _considerMovement = value ?? false;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
          CheckboxListTile(
            title: Text('Fase', style: TextStyle(color: Colors.green)),
            value: _considerPhase,
            onChanged: (bool? value) {
              setState(() {
                _considerPhase = value ?? false;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
          CheckboxListTile(
            title: Text('Posição', style: TextStyle(color: Colors.green)),
            value: _considerPosition,
            onChanged: (bool? value) {
              setState(() {
                _considerPosition = value ?? false;
              });
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sortTeams,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Center(
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
    // Ordenar jogadores por habilidade, fase, velocidade, movimentação e posição
    players.sort((a, b) {
      int compare = b.skillRating.compareTo(a.skillRating);
      if (compare == 0) compare = b.phase.compareTo(a.phase);
      if (compare == 0) compare = b.speed.compareTo(a.speed);
      if (compare == 0) compare = b.movement.compareTo(a.movement);
      return compare;
    });

    // Inicializar os times
    List<List<Player>> teams = List.generate(teamCount, (_) => []);

    // Distribuir jogadores nos times
    for (var player in players) {
      // Encontrar o time com menos jogadores
      List<Player> team = teams.reduce((a, b) => a.length < b.length ? a : b);

      // Verificar se o time já tem um goleiro
      bool hasGoalkeeper = team.any((p) => p.position == 'Goleiro');

      // Adicionar jogador ao time
      if (player.position == 'Goleiro' && hasGoalkeeper) {
        // Se o time já tem um goleiro, encontrar outro time
        for (var t in teams) {
          if (!t.any((p) => p.position == 'Goleiro')) {
            t.add(player);
            break;
          }
        }
      } else {
        team.add(player);
      }
    }

    // Balancear posições nos times
    for (var team in teams) {
      Map<String, int> positionCount = {};
      for (var player in team) {
        positionCount[player.position] = (positionCount[player.position] ?? 0) + 1;
      }

      // Se houver mais de um jogador na mesma posição (exceto goleiro), redistribuir
      for (var position in positionCount.keys) {
        if (position != 'Goleiro' && positionCount[position]! > 1) {
          for (var player in team.where((p) => p.position == position).skip(1)) {
            // Encontrar outro time com menos jogadores na mesma posição
            for (var t in teams) {
              if (t != team && t.where((p) => p.position == position).isEmpty) {
                t.add(player);
                team.remove(player);
                break;
              }
            }
          }
        }
      }
    }

    return teams;
  }
}
