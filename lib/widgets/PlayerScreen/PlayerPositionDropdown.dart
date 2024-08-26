import 'package:flutter/material.dart';

class PlayerPositionDropdown extends StatelessWidget {
  final String selectedPosition;
  final ValueChanged<String?> onChanged;

  const PlayerPositionDropdown({super.key, required this.selectedPosition, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedPosition,
      dropdownColor: Colors.black,
      onChanged: onChanged,
      items: <String>['Atacante', 'Meia', 'Defensor', 'Goleiro']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      hint: const Text('Selecione a Posição', style: TextStyle(color: Colors.white)),
      iconEnabledColor: Colors.green,
    );
  }
}