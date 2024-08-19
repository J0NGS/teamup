import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/screens/playerCreationScreen.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/utils/colors.dart';

class GroupDetailScreen extends StatelessWidget {
  final Group group;

  GroupDetailScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Black100, // Cor do AppBar
        iconTheme: IconThemeData(color: Colors.green), // Cor do ícone
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalhes do grupo: ${group.name}',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: group.players.length,
                itemBuilder: (context, index) {
                  Player player = group.players[index];
                  return CheckboxListTile(
                    title: Text(
                      player.name, // Exibe o nome do jogador
                      style: TextStyle(color: Colors.white),
                    ),
                    value: player.name.startsWith('*'), // Exemplo de lógica para check/uncheck
                    onChanged: (bool? checked) {
                      // Adicione aqui a lógica para atualizar o status do jogador
                      // Por exemplo, você pode marcar/desmarcar o jogador e salvar o estado
                    },
                    checkColor: Colors.green,
                    activeColor: Black100,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: BackgroundBlack, // Cor de fundo do Scaffold
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => PlayerCreationScreen(group: group))!.then((_){});
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add), // Cor do botão de ação flutuante
      ),
    );
  }
}
