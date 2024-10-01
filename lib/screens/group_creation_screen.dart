import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/models/group.dart';
import 'package:uuid/uuid.dart';

class GroupCreationScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GroupController groupController = Get.find<GroupController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Grupo'),
        backgroundColor: Black100,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Cadastrar Grupo',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.green),
              cursorColor: Colors.green,
              decoration: InputDecoration(
                labelText: 'Nome do grupo',
                labelStyle: const TextStyle(color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                prefixIconColor: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                    foregroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                  onPressed: () {
                    Get.back(); // volta para a tela anterior
                  },
                  child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                    foregroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) { // verifica se o campo de texto não está vazio
                      final newGroup = Group(id: Uuid().v4(), name: _controller.text);
                      groupController.addGroup(newGroup);
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
      backgroundColor: BackgroundBlack,
    );
  }
}