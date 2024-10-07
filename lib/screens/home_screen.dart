import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/widgets/groups_container.dart';
import 'package:teamup/screens/group_creation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TeamUp!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Black100,
      ),
      body: Container(
        color: BackgroundBlack, // Define a cor de fundo do body
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 16.0), // Define o padding desejado
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Grupos",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => GroupCreationScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Define a cor de fundo do botão
                foregroundColor:
                    Colors.black87, // Define a cor do ícone/texto do botão
              ),
              child: const Text("Criar Grupo",
                  style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: GroupsContainer(), // Exibe os grupos
            ),
          ],
        ),
      ),
    );
  }
}
