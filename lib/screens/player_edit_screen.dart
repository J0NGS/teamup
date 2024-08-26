import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/utils/colors.dart';
import '../widgets/PlayerScreen/ActionButton.dart';
import '../widgets/PlayerScreen/PlayerImagePicker.dart';
import '../widgets/PlayerScreen/PlayerNameField.dart';
import '../widgets/PlayerScreen/PlayerPositionDropdown.dart';
import '../widgets/PlayerScreen/PlayerSkillRatingField.dart';
import '../widgets/PlayerScreen/StrengthBar.dart';

class PlayerEditScreen extends StatefulWidget {
  final Group group;
  final Player player;

  const PlayerEditScreen({super.key, required this.group, required this.player});

  @override
  _PlayerEditScreenState createState() => _PlayerEditScreenState();
}

class _PlayerEditScreenState extends State<PlayerEditScreen> {
  late TextEditingController _nameController;
  late String _selectedPosition;
  late int _skillRating;
  late int _speed;
  late int _phase;
  late int _movement;
  late String _photoUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.player.name);
    _selectedPosition = widget.player.position;
    _skillRating = widget.player.skillRating;
    _speed = widget.player.speed;
    _phase = widget.player.phase;
    _movement = widget.player.movement;
    _photoUrl = widget.player.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Jogador', style: TextStyle(color: Colors.white)),
        backgroundColor: Black100,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Padding(
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
            const Spacer(),
            ActionButtons(
              onCancel: () {
                Navigator.pop(context);
              },
              onContinue: () {
                if (_nameController.text.isNotEmpty) {
                  final updatedPlayer = Player(
                    id: widget.player.id,
                    name: _nameController.text,
                    position: _selectedPosition,
                    skillRating: _skillRating,
                    speed: _speed,
                    phase: _phase,
                    movement: _movement,
                    photoUrl: _photoUrl,
                  );

                  final GroupController groupController = Get.find<GroupController>();
                  groupController.updatePlayer(widget.group, updatedPlayer);

                  Get.back(result: true);
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: BackgroundBlack,
    );
  }
}