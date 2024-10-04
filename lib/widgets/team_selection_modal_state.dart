import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/player_controller.dart';
import 'package:teamup/screens/team_result_screen.dart';
import 'package:teamup/widgets/team_selection_modal.dart';
import 'team_generator.dart';

class TeamSelectionModalState extends State<TeamSelectionModal> {
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
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Considerar:',
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          CheckboxListTile(
            title:
                const Text('Habilidade', style: TextStyle(color: Colors.green)),
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
            title:
                const Text('Velocidade', style: TextStyle(color: Colors.green)),
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
            title: const Text('Movimentação',
                style: TextStyle(color: Colors.green)),
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

  Future<void> _sortTeams() async {
    final PlayerController playerController = Get.find<PlayerController>();
    final int teamCount = int.tryParse(_teamCountController.text) ?? 0;
    if (teamCount <= 0) {
      Get.snackbar('Erro', 'Quantidade de times inválida',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    await playerController.loadPlayers(widget.group.id);
    final selectedPlayers = playerController.players
        .where((player) => player.isChecked.value)
        .toList();
    final sortedTeams = generateTeams(
      selectedPlayers,
      teamCount,
      _considerSkill,
      _considerSpeed,
      _considerMovement,
      _considerPhase,
      _considerPosition,
    );

    Get.to(() => TeamResultScreen(teams: sortedTeams));
  }
}
