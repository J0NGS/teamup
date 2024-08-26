import 'package:flutter/material.dart';

class PlayerSkillRatingField extends StatelessWidget {
  final int skillRating;
  final ValueChanged<int> onChanged;

  const PlayerSkillRatingField({super.key, required this.skillRating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Habilidade (0-100)',
        labelStyle: TextStyle(color: Colors.green),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        int? newValue = int.tryParse(value);
        if (newValue != null && newValue <= 100) {
          onChanged(newValue);
        }
      },
      controller: TextEditingController(text: skillRating.toString()),
    );
  }
}