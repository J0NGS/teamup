import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/screens/playerCreationScreen.dart';
import 'package:teamup/screens/player_edit_screen.dart'; // Importar a tela de edição
import 'package:teamup/utils/colors.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;

  GroupDetailScreen({required this.group});

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
              // Remove players that are checked
              groupController.removeCheckedPlayers(group);
              // Força a atualização da tela
              groupController.groups.refresh();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final updatedGroup = groupController.groups.firstWhere((g) => g.name == group.name);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes do grupo: ${updatedGroup.name}',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
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
                              : Image.network(
                            player.photoUrl,
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
                              Spacer(),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: _getSkillRatingColor(player.skillRating),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                constraints: BoxConstraints(
                                  maxWidth: 80,
                                  minWidth: 80,
                                ),
                                child: Center(
                                  child: Text(
                                    '${player.skillRating}',
                                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                              ),
                              Spacer(flex: 100,),
                              Checkbox(
                                value: player.isChecked,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    player.isChecked = value;
                                    groupController.updatePlayerCheckedState(group, player);
                                    // Força a atualização da tela
                                    groupController.groups.refresh();
                                  }
                                },
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      backgroundColor: BackgroundBlack,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => PlayerCreationScreen(group: group))!.then((result) {
            if (result == true) {
              groupController.groups.refresh();
            }
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
