import 'package:flutter/material.dart';  // Importa o pacote Flutter Material para criar widgets e temas
import 'package:get/get.dart';  // Importa o pacote GetX para gerenciamento de estado e navegação
import 'package:teamup/controllers/group_controller.dart';  // Importa o controlador de grupos
import 'package:teamup/utils/colors.dart';  // Importa o arquivo de cores personalizado
import 'package:teamup/widgets/groups_container.dart';  // Importa o widget que exibe os grupos
import 'package:teamup/screens/group_creation_screen.dart';  // Importa a tela de criação de grupo

import 'coming_soon.dart'; // Importa a tela padrão que será exibida para as opções de "Campeonatos" e "Configurações"

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Cria uma instância do GroupController e a coloca no GetX para gerenciamento de estado
    final GroupController groupController = Get.put(GroupController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TeamUp!',  // Define o título da AppBar
          textAlign: TextAlign.center,  // Alinha o texto ao centro
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),  // Define a cor e o peso da fonte
        ),
        backgroundColor: Black100,  // Define a cor de fundo da AppBar
      ),
      body: GroupsContainer(),  // Exibe o widget que mostra os grupos
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a tela de criação de grupo quando o botão flutuante é pressionado
          Get.to(() => GroupCreationScreen());
        },
        backgroundColor: Colors.green,  // Define a cor de fundo do botão flutuante
        child: const Icon(Icons.add),  // Ícone do botão flutuante
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),  // Ícone para a aba Home
            label: 'Home',  // Rótulo da aba Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),  // Ícone para a aba Campeonatos
            label: 'Campeonatos',  // Rótulo da aba Campeonatos
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),  // Ícone para a aba Configurações
            label: 'Configurações',  // Rótulo da aba Configurações
          ),
        ],
        currentIndex: 0,  // Define a aba atual como Home
        selectedItemColor: Colors.green,  // Cor do item selecionado
        unselectedItemColor: Colors.grey,  // Cor dos itens não selecionados
        onTap: (index) {
          // Navega para a tela ComingSoonScreen para as opções de "Campeonatos" e "Configurações"
          switch (index) {
            case 1: // Campeonatos
            case 2: // Configurações
              Get.to(() => ComingSoonScreen());
              break;
            default:
              break;
          }
        },
        backgroundColor: Black100,  // Define a cor de fundo da BottomNavigationBar
      ),
    );
  }
}
