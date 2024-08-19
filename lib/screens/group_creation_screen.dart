import 'package:flutter/material.dart';  // Importa o pacote Flutter Material, que fornece widgets e temas para criar a interface do usuário
import 'package:get/get.dart';  // Importa o pacote GetX para gerenciamento de estado e navegação
import 'package:teamup/controllers/group_controller.dart';  // Importa o controlador de grupos
import 'package:teamup/utils/colors.dart';  // Importa o arquivo de cores personalizado do aplicativo
import 'package:teamup/models/group.dart';  // Importa a classe Group

// Define uma tela para criar um novo grupo
class GroupCreationScreen extends StatelessWidget {
  // Controlador de texto para o campo de entrada do nome do grupo
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Obtém uma instância do GroupController usando GetX
    final GroupController groupController = Get.find<GroupController>();

    // Constrói a interface do usuário para a tela de criação de grupo
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Grupo'),  // Define o título da AppBar
        backgroundColor: Black100,  // Define a cor de fundo da AppBar
        iconTheme: const IconThemeData(
            color: Colors.green  // Define a cor dos ícones na AppBar
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Define o espaçamento interno ao redor do conteúdo
        child: Column(
          children: [
            const Text(
              'Cadastrar Grupo',  // Texto do título da tela
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),  // Estilo do texto
            ),
            TextField(
              controller: _controller,  // Controlador para o campo de texto
              style: const TextStyle(color: Colors.green),  // Define a cor do texto digitado
              cursorColor: Colors.green,  // Define a cor do cursor
              decoration: InputDecoration(
                  labelText: 'Nome do Grupo',  // Texto do rótulo do campo de entrada
                  labelStyle: const TextStyle(color: Colors.green),  // Define a cor do rótulo
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),  // Define o raio de curvatura dos cantos da borda
                    borderSide: const BorderSide(color: Colors.grey),  // Cor da borda quando o campo não está em foco
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),  // Define o raio de curvatura dos cantos da borda
                    borderSide: const BorderSide(color: Colors.green),  // Cor da borda quando o campo está em foco
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),  // Define o raio de curvatura dos cantos da borda
                    borderSide: const BorderSide(color: Colors.grey),  // Cor da borda quando o campo está habilitado
                  ),
                  prefixIconColor: Colors.green  // Define a cor do ícone prefixo
              ),
            ),
            const SizedBox(height: 20),  // Espaçamento vertical entre o campo de texto e os botões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,  // Distribui os botões igualmente ao longo da linha
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red),  // Define a cor de fundo do botão
                    foregroundColor: WidgetStatePropertyAll(Colors.black),  // Define a cor do texto do botão
                  ),
                  onPressed: () {
                    Get.back();  // Navega de volta para a tela anterior
                  },
                  child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),  // Texto do botão
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),  // Define a cor de fundo do botão
                    foregroundColor: WidgetStatePropertyAll(Colors.black),  // Define a cor do texto do botão
                  ),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {  // Verifica se o campo de texto não está vazio
                      // Cria um novo grupo com o nome inserido
                      final newGroup = Group(name: _controller.text);
                      groupController.addGroup(newGroup);  // Adiciona o novo grupo ao GroupController
                      Get.back();  // Navega de volta para a tela anterior
                    }
                  },
                  child: const Text('Continuar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),  // Texto do botão
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: BackgroundBlack,  // Define a cor de fundo da tela
    );
  }
}
