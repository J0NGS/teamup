import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
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
  final Player player;
  final PlayerController playerController = Get.put(PlayerController());

  PlayerEditScreen({required this.player}) {
    playerController.nameController.value =
        TextEditingController(text: player.name.value).value;
    playerController.setSelectedPosition(player.position.value);
    playerController.setSkillRating(player.skillRating.value);
    playerController.setSpeed(player.speed.value);
    playerController.setPhase(player.phase.value);
    playerController.setMovement(player.movement.value);
    playerController.setPhotoUrl(player.photoUrl.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Editar Jogador', style: TextStyle(color: Colors.white)),
        backgroundColor: Black100,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Obx(() => PlayerImagePicker(
                  photoUrl: player.photoUrl.value,
                  onImagePicked: (path) {
                    playerController.setPhotoUrl(path);
                  },
                )),
            const SizedBox(height: 20),
            PlayerNameField(controller: playerController.nameController),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Obx(() => PlayerPositionDropdown(
                        selectedPosition:
                            playerController.selectedPosition.value,
                        onChanged: (newValue) {
                          playerController.setSelectedPosition(newValue!);
                        },
                      )),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Obx(() => PlayerSkillRatingField(
                        initialValue: player.skillRating.value,
                        skillRating: playerController.skillRating.value,
                        onChanged: (newValue) {
                          playerController.setSkillRating(newValue);
                        },
                      )),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() => StrengthBar(
                label: 'Velocidade',
                value: playerController.speed.value,
                onChanged: (value) {
                  playerController.setSpeed(value);
                })),
            const SizedBox(height: 20),
            Obx(() => StrengthBar(
                label: 'Movimentação',
                value: playerController.movement.value,
                onChanged: (value) {
                  playerController.setMovement(value);
                })),
            const SizedBox(height: 20),
            Obx(() => StrengthBar(
                label: 'Fase',
                value: playerController.phase.value,
                onChanged: (value) {
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
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (playerController.nameController.text.isNotEmpty) {
                      final updatedPlayer = Player(
                        id: player.id.value,
                        name: playerController.nameController.text,
                        position: playerController.selectedPosition.value,
                        skillRating: playerController.skillRating.value,
                        speed: playerController.speed.value,
                        phase: playerController.phase.value,
                        movement: playerController.movement.value,
                        photoUrl: playerController.photoUrl.value,
                        isChecked: player.isChecked.value,
                        groupId: player.groupId.value,
                      );
                      playerController.updatePlayer(updatedPlayer);
                      Get.back(result: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
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
