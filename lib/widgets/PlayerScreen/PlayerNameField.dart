import 'package:flutter/material.dart';

class PlayerNameField extends StatelessWidget {
  final TextEditingController controller;

  const PlayerNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Nome',
        labelStyle: TextStyle(color: Colors.green),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}