import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerSkillRatingField extends StatefulWidget {
  final int skillRating;
  final ValueChanged<int> onChanged;
  final int? initialValue;

  const PlayerSkillRatingField({super.key, required this.skillRating, required this.onChanged, this.initialValue});

  @override
  _PlayerSkillRatingFieldState createState() => _PlayerSkillRatingFieldState();
}

class _PlayerSkillRatingFieldState extends State<PlayerSkillRatingField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue?.toString() ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,3}$')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) {
            return newValue;
          }
          final intValue = int.tryParse(newValue.text);
          if (intValue == null || intValue > 100) {
            return oldValue;
          }
          return newValue;
        }),
      ],
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
          widget.onChanged(newValue);
        }
      },
    );
  }
}