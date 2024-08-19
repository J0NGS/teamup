import 'package:flutter/material.dart';  // Importa o pacote Flutter Material, que fornece widgets e temas para criar a interface do usuário
import 'package:teamup/utils/colors.dart';  // Importa o arquivo de cores personalizado do aplicativo

// Define uma tela para mostrar uma mensagem de "Em breve..."
class ComingSoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Constrói a interface do usuário para a tela "Em breve..."
    return Scaffold(
      backgroundColor: BackgroundBlack,  // Define a cor de fundo da tela usando a cor personalizada BackgroundBlack
      appBar: AppBar(
        title: const Text(
          'Em breve...',  // Define o título da AppBar
          style: TextStyle(color: Colors.green),  // Define o estilo do texto do título, com a cor verde
        ),
        backgroundColor: Black100,  // Define a cor de fundo da AppBar usando a cor personalizada Black100
      ),
      body: const Center(
        // Centraliza o conteúdo dentro do corpo da tela
        child: Text(
          'Em breve...',  // Define o texto que será exibido no corpo da tela
          style: TextStyle(
            fontSize: 40,  // Define o tamanho da fonte como 40
            fontWeight: FontWeight.bold,  // Define o peso da fonte como negrito
            color: Colors.white,  // Define a cor do texto como branco
          ),
        ),
      ),
    );
  }
}
