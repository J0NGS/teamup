import 'package:flutter/material.dart';
import 'package:teamup/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teamup',
      home: HomeScreen(),  // Aqui você chama a HomeScreen
    );
  }
}