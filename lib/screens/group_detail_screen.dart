import 'dart:io'; // Import necessário para trabalhar com arquivos locais
import 'package:flutter/foundation.dart'; // Import necessário para detectar se está na web
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/screens/playerCreationScreen.dart';
import 'package:teamup/screens/player_edit_screen.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/widgets/team_selection_modal.dart';

// Tela que exibe detalhes de um grupo
class GroupDetailScreen extends StatelessWidget {
  final Group group; // Grupo a ser exibido

  GroupDetailScreen({required this.group}); // Construtor

  // Obtém a cor para o skill rating
  Color _getSkillRatingColor(int skillRating) {
    double ratio = skillRating / 100.0;
    int red = (255 * (1 - ratio)).toInt();
    int green = (255 * ratio).toInt();
    return Color.fromARGB(255, red, green, 0);
  }

  @override
  Widget build(BuildContext context) {
    final GroupController groupController = Get.find<GroupController>();

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Grupo: ${group.name}", style: const TextStyle(color: Colors.white)),
        backgroundColor: Black100,
        iconTheme: const IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              groupController.removeCheckedPlayers(group);
              groupController.groups.refresh();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Obx(() {
          final updatedGroup =
              groupController.groups.firstWhere((g) => g.name == group.name);
          final selectedPlayersCount =
              updatedGroup.players.where((p) => p.isChecked).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => PlayerCreationScreen(group: group))!
                        .then((result) {
                      if (result == true) {
                        groupController.groups.refresh();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Define a cor de fundo do botão
                    foregroundColor:
                        Colors.black87, // Define a cor do ícone/texto do botão
                  ),
                  child: const Text("Criar Jogador",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: updatedGroup.players.length,
                  itemBuilder: (context, index) {
                    Player player = updatedGroup.players[index];
                    return Card(
                      color: Black100,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => PlayerEditScreen(
                                  group: updatedGroup, player: player))!
                              .then((result) {
                            if (result == true) {
                              groupController.groups.refresh();
                            }
                          });
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: player.photoUrl.isEmpty
                              ? const Icon(Icons.person,
                                  color: Colors.green, size: 50)
                              : kIsWeb
                                  ? Image.network(
                                      player.photoUrl,
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.person,
                                            color: Colors.green, size: 50);
                                      },
                                    )
                                  : Image.file(
                                      File(player.photoUrl),
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.person,
                                            color: Colors.green, size: 50);
                                      },
                                    ),
                          title: Row(
                            children: [
                              Text(
                                player.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                              const Spacer(flex: 100),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color:
                                      _getSkillRatingColor(player.skillRating),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                constraints:
                                    const BoxConstraints(maxWidth: 80, minWidth: 80),
                                child: Center(
                                  child: Text(
                                    '${player.skillRating}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Checkbox(
                                value: player.isChecked,
                                activeColor: Colors.green,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    player.isChecked = value;
                                    groupController.updatePlayerCheckedState(
                                        group, player);
                                    groupController.groups.refresh();
                                  }
                                },
                              ),
                            ],
                          ),
                          subtitle: const Row(
                            children: [Spacer()],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    TeamSelectionModal(
                        selectedPlayersCount: selectedPlayersCount,
                        group: group),
                    backgroundColor: Black100,
                    isScrollControlled: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 70),
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Sortear Times',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '$selectedPlayersCount jogadores selecionados',
                      style: const TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      backgroundColor: BackgroundBlack,
    );
  }
}
