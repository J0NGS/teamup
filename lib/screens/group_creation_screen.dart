import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/models/group.dart';

class GroupCreationScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController(); // controlador do campo de texto

  @override
  Widget build(BuildContext context) {
    final GroupController groupController = Get.find<GroupController>(); // instancia o controlador de grupos

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Grupo'), // título da appbar
        backgroundColor: Black100, // cor de fundo da appbar
        iconTheme: const IconThemeData(color: Colors.green), // cor dos ícones
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // espaçamento interno
        child: Column(
          children: [
            const Text(
              'Cadastrar Grupo', // título da tela
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            TextField(
              controller: _controller, // controlador do campo de texto
              style: const TextStyle(color: Colors.green), // cor do texto digitado
              cursorColor: Colors.green, // cor do cursor
              decoration: InputDecoration(
                labelText: 'Nome do Grupo', // rótulo do campo
                labelStyle: const TextStyle(color: Colors.green), // cor do rótulo
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // cantos arredondados
                  borderSide: const BorderSide(color: Colors.grey), // cor da borda inativa
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // cantos arredondados
                  borderSide: const BorderSide(color: Colors.green), // cor da borda ativa
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // cantos arredondados
                  borderSide: const BorderSide(color: Colors.grey), // cor da borda habilitada
                ),
                prefixIconColor: Colors.green, // cor do ícone prefixo
              ),
            ),
            const SizedBox(height: 20), // espaçamento entre o campo e os botões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // distribuição dos botões
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red), // cor de fundo do botão
                    foregroundColor: WidgetStatePropertyAll(Colors.black), // cor do texto do botão
                  ),
                  onPressed: () {
                    Get.back(); // volta para a tela anterior
                  },
                  child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green), // cor de fundo do botão
                    foregroundColor: WidgetStatePropertyAll(Colors.black), // cor do texto do botão
                  ),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) { // verifica se o campo de texto não está vazio
                      final newGroup = Group(name: _controller.text); // cria novo grupo
                      groupController.addGroup(newGroup); // adiciona o grupo ao controlador
                      Get.back(); // volta para a tela anterior
                    }
                  },
                  child: const Text('Continuar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: BackgroundBlack, // cor de fundo da tela
    );
  }
}
