import 'package:flutter/material.dart';
import 'package:teamup/utils/colors.dart';

class ComingSoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundBlack,  // cor de fundo personalizada
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        title: const Text(
          'Em breve...',  // título da appbar
          style: TextStyle(color: Colors.green),  // texto verde
        ),
        backgroundColor: Black100,  // cor de fundo da appbar
      ),
      body: const Center(
        child: Text(
          'Em breve...',  // texto centralizado
          style: TextStyle(
            fontSize: 40,  // tamanho da fonte
            fontWeight: FontWeight.bold,  // texto em negrito
            color: Colors.white,  // cor do texto
          ),
        ),
      ),
    );
  }
}
