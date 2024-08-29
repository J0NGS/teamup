import 'dart:io';  // Import necessário para trabalhar com arquivos locais
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
  final Group group;  // Grupo a ser exibido

  GroupDetailScreen({required this.group});  // Construtor

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
        title: Text(group.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Black100,
        iconTheme: IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              groupController.removeCheckedPlayers(group);
              groupController.groups.refresh();
            },
          ),
          IconButton(
              icon: Icon(Icons.add, color: Colors.green),
              onPressed: () {
                Get.to(() => PlayerCreationScreen(group: group))!.then((result) {
                  if (result == true) {
                    groupController.groups.refresh();
                  }
                });
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final updatedGroup = groupController.groups.firstWhere((g) => g.name == group.name);
          final selectedPlayersCount = updatedGroup.players.where((p) => p.isChecked).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: updatedGroup.players.length,
                  itemBuilder: (context, index) {
                    Player player = updatedGroup.players[index];
                    return Card(
                      color: Black100,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => PlayerEditScreen(group: updatedGroup, player: player))!.then((result) {
                            if (result == true) {
                              groupController.groups.refresh();
                            }
                          });
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          leading: player.photoUrl.isEmpty
                              ? Icon(Icons.person, color: Colors.green, size: 50)
                              : Image.file(
                            File(player.photoUrl),
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.person, color: Colors.green, size: 50);
                            },
                          ),
                          title: Row(
                            children: [
                              Text(
                                player.name,
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              ),
                              Spacer(flex: 100),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: _getSkillRatingColor(player.skillRating),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                constraints: BoxConstraints(maxWidth: 80, minWidth: 80),
                                child: Center(
                                  child: Text(
                                    '${player.skillRating}',
                                    style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Checkbox(
                                value: player.isChecked,
                                activeColor: Colors.green,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    player.isChecked = value;
                                    groupController.updatePlayerCheckedState(group, player);
                                    groupController.groups.refresh();
                                  }
                                },
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [Spacer()],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    TeamSelectionModal(selectedPlayersCount: selectedPlayersCount, group: group),
                    backgroundColor: Black100,
                    isScrollControlled: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 70),
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                ),
                child: Column(
                  children: [
                    Text(
                      'Selecionar Times',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '$selectedPlayersCount jogadores selecionados',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
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
