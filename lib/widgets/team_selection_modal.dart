import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/screens/team_result_screen.dart';
import 'package:teamup/utils/colors.dart';

class TeamSelectionModal extends StatefulWidget {
  final Group group;
  final int selectedPlayersCount;

  TeamSelectionModal({required this.group, required this.selectedPlayersCount});

  @override
  _TeamSelectionModalState createState() => _TeamSelectionModalState();
}

class _TeamSelectionModalState extends State<TeamSelectionModal> {
  final TextEditingController _teamCountController = TextEditingController();
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
          Text(
            'Configurações do Sorteio',
            style: TextStyle(fontSize: 24, color: Colors.white),
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
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          CheckboxListTile(
            title: Text('Velocidade', style: TextStyle(color: Colors.white)),
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
            title: Text('Movimentação', style: TextStyle(color: Colors.white)),
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
            title: Text('Fase', style: TextStyle(color: Colors.white)),
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
            title: Text('Posição', style: TextStyle(color: Colors.white)),
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
            onPressed: () {
              _sortTeams();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Center(
              child: Text('Sortear'),
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

    // Filtrar jogadores selecionados
    final selectedPlayers = widget.group.players.where((player) => player.isChecked).toList();

    // Lógica de sorteio
    final sortedTeams = _generateTeams(selectedPlayers, teamCount);

    Get.to(() => TeamResultScreen(teams: sortedTeams));
  }

  List<List<Player>> _generateTeams(List<Player> players, int teamCount) {
    // Implementar a lógica de sorteio considerando os pesos
    // Exemplo básico de divisão igualitária sem considerar pesos específicos
    List<List<Player>> teams = List.generate(teamCount, (_) => []);

    for (int i = 0; i < players.length; i++) {
      teams[i % teamCount].add(players[i]);
    }

    return teams;
  }
}
