import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/group_controller.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/utils/colors.dart';

class PlayerCreationScreen extends StatefulWidget {
  final Group group;

  PlayerCreationScreen({required this.group});

  @override
  _PlayerCreationScreenState createState() => _PlayerCreationScreenState();
}

class _PlayerCreationScreenState extends State<PlayerCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedPosition = 'Atacante';
  int _skillRating = 0;
  int _speed = 1;
  int _phase = 1;
  int _movement = 1;
  String _photoUrl = '';

  Color _getSliderColor(int value) {
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _photoUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Jogador', style: TextStyle(color: Colors.white)),
        backgroundColor: Black100,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Black100,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 3),
                  image: _photoUrl.isNotEmpty
                      ? DecorationImage(
                    image: FileImage(File(_photoUrl)),
                    fit: BoxFit.contain,
                  )
                      : null,
                ),
                child: _photoUrl.isEmpty
                    ? Icon(Icons.person, color: Colors.green, size: 100)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                labelStyle: TextStyle(color: Colors.green),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedPosition,
                    dropdownColor: Black100,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPosition = newValue!;
                      });
                    },
                    items: <String>['Atacante', 'Meia', 'Defensor', 'Goleiro']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    hint: const Text('Selecione a Posição', style: TextStyle(color: Colors.white)),
                    iconEnabledColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Nota de Habilidade (0-100)',
                      labelStyle: TextStyle(color: Colors.green),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        int? newValue = int.tryParse(value);
                        if (newValue != null && newValue <= 100) {
                          _skillRating = newValue;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSlider('Velocidade', _speed, (value) {
              setState(() {
                _speed = value;
              });
            }),
            const SizedBox(height: 20),
            _buildSlider('Movimentação', _movement, (value) {
              setState(() {
                _movement = value;
              });
            }),
            const SizedBox(height: 20),
            _buildSlider('Fase', _phase, (value) {
              setState(() {
                _phase = value;
              });
            }),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      final newPlayer = Player(
                        name: _nameController.text,
                        position: _selectedPosition,
                        skillRating: _skillRating,
                        speed: _speed,
                        phase: _phase,
                        movement: _movement,
                        photoUrl: _photoUrl,
                      );

                      final GroupController groupController = Get.find<GroupController>();
                      groupController.addPlayerToGroup(widget.group, newPlayer);

                      Get.back(result: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: BackgroundBlack,
    );
  }

  Widget _buildSlider(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 3,
            divisions: 2,
            onChanged: (double newValue) {
              onChanged(newValue.toInt());
            },
            label: '$value',
            activeColor: _getSliderColor(value),
            inactiveColor: Colors.white30,
          ),
        ),
      ],
    );
  }
}
