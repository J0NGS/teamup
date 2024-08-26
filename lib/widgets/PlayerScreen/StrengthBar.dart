import 'package:flutter/material.dart';

class StrengthBar extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const StrengthBar({required this.label, required this.value, required this.onChanged});

  Color _getBarColor(int value) {
    switch (value) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Row(
          children: List.generate(3, (index) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  onChanged(index + 1);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  height: 20.0, // Espessura das barras
                  color: index < value ? _getBarColor(value) : Colors.white30,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}