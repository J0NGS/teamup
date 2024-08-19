import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/screens/playerCreationScreen.dart';
  import 'package:teamup/utils/colors.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;

  GroupDetailScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    final GroupController groupController = Get.find<GroupController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Black100,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Reagir às mudanças na lista de jogadores
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
                    return CheckboxListTile(
                      title: Text(
                        player.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      secondary: player.photoUrl.isEmpty
                          ? Icon(Icons.person, color: Colors.green, size: 50)
                          : Image.network(
                        "player.photoUrl",
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person, color: Colors.green, size: 50);
                        },
                      ),
                      value: false, // Exemplo de lógica para check/uncheck
                      onChanged: (bool? checked) {
                        // Adicione aqui a lógica para atualizar o status do jogador
                      },
                      checkColor: Colors.green,
                      activeColor: Black100,
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
              // Atualiza a tela ao voltar
              Get.forceAppUpdate();
            }
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
