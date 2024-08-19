import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/utils/colors.dart';

import '../controllers/group_controller.dart';

class PlayerCreationScreen extends StatefulWidget {
  final Group group;

  PlayerCreationScreen({required this.group});

  @override
  _PlayerCreationScreenState createState() => _PlayerCreationScreenState();
}

class _PlayerCreationScreenState extends State<PlayerCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedPosition = 'Atacante'; // Valor inicial
  int _skillRating = 0;
  int _speed = 1;
  int _phase = 1;
  int _movement = 1;
  String _photoUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Jogador', style: TextStyle(color: Colors.white)),
        backgroundColor: Black100,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Implementar lógica para adicionar a foto
              },
              child: Container(
                color: Black100,
                width: double.infinity,
                height: 150,
                child: const Center(
                  child: Text('Adicionar Foto', style: TextStyle(color: Colors.green)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                labelStyle: TextStyle(color: Colors.green),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedPosition,
              dropdownColor: Black100,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPosition = newValue!;
                });
              },
              items: <String>['Atacante', 'Meia', 'Defensor', 'Goleiro']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              hint: const Text('Selecione a Posição', style: TextStyle(color: Colors.white)),
              iconEnabledColor: Colors.green,
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nota de Habilidade (0-100)',
                labelStyle: TextStyle(color: Colors.green),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _skillRating = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Velocidade', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: _speed.toDouble(),
                    min: 1,
                    max: 3,
                    divisions: 2,
                    onChanged: (value) {
                      setState(() {
                        _speed = value.toInt();
                      });
                    },
                    label: '$_speed',
                    activeColor: Colors.green,
                    inactiveColor: Colors.white30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Fase', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: _phase.toDouble(),
                    min: 1,
                    max: 3,
                    divisions: 2,
                    onChanged: (value) {
                      setState(() {
                        _phase = value.toInt();
                      });
                    },
                    label: '$_phase',
                    activeColor: Colors.green,
                    inactiveColor: Colors.white30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Movimentação', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: _movement.toDouble(),
                    min: 1,
                    max: 3,
                    divisions: 2,
                    onChanged: (value) {
                      setState(() {
                        _movement = value.toInt();
                      });
                    },
                    label: '$_movement',
                    activeColor: Colors.green,
                    inactiveColor: Colors.white30,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      final newPlayer = Player(
                        name: _nameController.text,
                        position: _selectedPosition,
                        skillRating: _skillRating,
                        speed: _speed,
                        phase: _phase,
                        movement: _movement,
                        photoUrl: _photoUrl,
                      );

                      // Adicionar o jogador ao grupo e persistir
                      final GroupController groupController = Get.find<GroupController>();
                      groupController.addPlayerToGroup(widget.group, newPlayer);

                      // Voltar à tela anterior e atualizar a lista de jogadores
                      Get.back();
                    }
                  },
                  child: const Text(
                    'Continuar',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
      backgroundColor: BackgroundBlack,
    );
  }
}
