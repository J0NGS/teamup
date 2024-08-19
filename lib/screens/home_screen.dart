import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/widgets/groups_container.dart';
import 'package:teamup/screens/group_creation_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GroupController groupController = Get.put(GroupController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TeamUp!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Black100,
      ),
      body: GroupsContainer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => GroupCreationScreen());
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Campeonatos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Lógica para mudar de tela com base na aba selecionada
        },
        backgroundColor: Black100,
      ),
    );
  }
}
