// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:teamup/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Aqui você pode armazenar a lista de grupos e o estado da tela
  List<String> grupos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TeamUp!', textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        backgroundColor: Black100,

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: BackgroundBlack,
        child: Center(
          child: grupos.isEmpty
              ? Text('Nenhum grupo criado', style: TextStyle(color: Colors.white),)
              : ListView.builder(
            itemCount: grupos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(grupos[index],  style: TextStyle(color: Colors.white)),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para adicionar um novo grupo
          setState(() {
            grupos.add('Novo Grupo ${grupos.length + 1}');
          });
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Grupos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          // Lógica para mudar de tela com base na aba selecionada
        },
        backgroundColor: Black100,
      ),
    );
  }
}
