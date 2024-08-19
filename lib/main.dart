import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Teamup',
      theme: ThemeData(primaryColor: Colors.green),
      home: HomeScreen(),  // Aqui você chama a HomeScreen
    );
  }
}
