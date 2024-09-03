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
import '../controllers/player_controller.dart';

class PlayerEditScreen extends StatelessWidget {
  final Group group;
  final Player player;
  final PlayerController playerController = Get.put(PlayerController());

  PlayerEditScreen({required this.group, required this.player}) {
    playerController.setName(player.name);
    playerController.setSelectedPosition(player.position);
    playerController.setSkillRating(player.skillRating);
    playerController.setSpeed(player.speed);
    playerController.setPhase(player.phase);
    playerController.setMovement(player.movement);
    playerController.setPhotoUrl(player.photoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Jogador', style: TextStyle(color: Colors.white)),
        backgroundColor: Black100,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Obx(() => PlayerImagePicker(
              photoUrl: playerController.photoUrl.value,
              onImagePicked: (path) {
                playerController.setPhotoUrl(path);
              },
            )),
            const SizedBox(height: 20),
            Obx(() => PlayerNameField(controller: TextEditingController(text: playerController.name.value))),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Obx(() => PlayerPositionDropdown(
                    selectedPosition: playerController.selectedPosition.value,
                    onChanged: (newValue) {
                      playerController.setSelectedPosition(newValue!);
                    },
                  )),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Obx(() => PlayerSkillRatingField(
                    skillRating: playerController.skillRating.value,
                    onChanged: (newValue) {
                      playerController.setSkillRating(newValue);
                    },
                    initialValue: player.skillRating,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() => StrengthBar(label: 'Velocidade', value: playerController.speed.value, onChanged: (value) {
              playerController.setSpeed(value);
            })),
            const SizedBox(height: 20),
            Obx(() => StrengthBar(label: 'Movimentação', value: playerController.movement.value, onChanged: (value) {
              playerController.setMovement(value);
            })),
            const SizedBox(height: 20),
            Obx(() => StrengthBar(label: 'Fase', value: playerController.phase.value, onChanged: (value) {
              playerController.setPhase(value);
            })),
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
                    if (playerController.name.value.isNotEmpty) {
                      final updatedPlayer = Player(
                        id: player.id,
                        name: playerController.name.value,
                        position: playerController.selectedPosition.value,
                        skillRating: playerController.skillRating.value,
                        speed: playerController.speed.value,
                        phase: playerController.phase.value,
                        movement: playerController.movement.value,
                        photoUrl: playerController.photoUrl.value,
                      );

                      final GroupController groupController = Get.find<GroupController>();
                      groupController.updatePlayer(group, updatedPlayer);

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