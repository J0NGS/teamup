import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/utils/colors.dart';
import 'package:uuid/uuid.dart';
import '../widgets/PlayerScreen/ActionButton.dart';
import '../widgets/PlayerScreen/PlayerImagePicker.dart';
import '../widgets/PlayerScreen/PlayerNameField.dart';
import '../widgets/PlayerScreen/PlayerPositionDropdown.dart';
import '../widgets/PlayerScreen/PlayerSkillRatingField.dart';
import '../widgets/PlayerScreen/StrengthBar.dart';

class PlayerCreationScreen extends StatefulWidget {
  final Group group;

  PlayerCreationScreen({required this.group});

  @override
  _PlayerCreationScreenState createState() => _PlayerCreationScreenState();
}

class _PlayerCreationScreenState extends State<PlayerCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedPosition = 'Atacante';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            PlayerImagePicker(
              photoUrl: _photoUrl,
              onImagePicked: (path) {
                setState(() {
                  _photoUrl = path;
                });
              },
            ),
            const SizedBox(height: 20),
            PlayerNameField(controller: _nameController),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PlayerPositionDropdown(
                    selectedPosition: _selectedPosition,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPosition = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: PlayerSkillRatingField(
                    skillRating: _skillRating,
                    onChanged: (newValue) {
                      setState(() {
                        _skillRating = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            StrengthBar(label: 'Velocidade', value: _speed, onChanged: (value) {
              setState(() {
                _speed = value;
              });
            }),
            const SizedBox(height: 20),
            StrengthBar(label: 'Movimentação', value: _movement, onChanged: (value) {
              setState(() {
                _movement = value;
              });
            }),
            const SizedBox(height: 20),
            StrengthBar(label: 'Fase', value: _phase, onChanged: (value) {
              setState(() {
                _phase = value;
              });
            }),
            const SizedBox(height: 20),
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
                        id: Uuid().v4(),
                        name: _nameController.text,
                        position: _selectedPosition,
                        skillRating: _skillRating,
                        speed: _speed,
                        phase: _phase,
                        movement: _movement,
                        photoUrl: _photoUrl,
                      );

                      final GroupController groupController = Get.find<GroupController>();
                      groupController.addPlayerToGroup(widget.group, newPlayer);

                      Get.back(result: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
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