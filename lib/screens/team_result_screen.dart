import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/player.dart';
import '../utils/colors.dart';
import 'ScoreBoardScreen.dart';

class TeamResultScreen extends StatelessWidget {
  final List<List<Player>> teams;
  TeamResultScreen({required this.teams});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _timeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Times Sorteados', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Black100,
        actions: [
          IconButton(
            icon: Icon(Icons.timer, color: Colors.green),
            onPressed: () async {
              int? pickedMinutes;
              int? pickedSeconds;

              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        backgroundColor: Black100,
                        title: const Text('Selecione o Tempo', style: TextStyle(color: Colors.green)),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DropdownButton<int>(
                              value: pickedMinutes,
                              hint: const Text('Minutos', style: TextStyle(color: Colors.green)),
                              dropdownColor: Black100,
                              items: List.generate(60, (index) => index).map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString().padLeft(2, '0'), style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  pickedMinutes = value;
                                });
                              },
                            ),
                            DropdownButton<int>(
                              value: pickedSeconds,
                              hint: const Text('Segundos', style: TextStyle(color: Colors.green)),
                              dropdownColor: Black100,
                              items: List.generate(60, (index) => index).map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString().padLeft(2, '0'), style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  pickedSeconds = value;
                                });
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () {
                              if (pickedMinutes != null && pickedSeconds != null) {
                                _timeController.text = '${pickedMinutes.toString().padLeft(2, '0')}:${pickedSeconds.toString().padLeft(2, '0')}';
                                final int totalSeconds = (pickedMinutes! * 60) + pickedSeconds!;
                                if (totalSeconds > 0) {
                                  Get.to(() => ScoreboardScreen(timer: totalSeconds));
                                }
                              }
                            },
                            child: const Text('OK', style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            final averageRating = team.map((p) => p.skillRating).reduce((a, b) => a + b) / team.length;
            final highestRating = team.map((p) => p.skillRating).reduce((a, b) => a > b ? a : b);

            return Card(
              color: Black100,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Média de Nota: ${averageRating.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    Text(
                      'Maior Nota: $highestRating',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    ...team.map((player) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${player.name} - ${player.position} - V:${player.speed} - M:${player.movement} - F:${player.phase}',
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: _getSkillRatingColor(player.skillRating),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              constraints: const BoxConstraints(maxWidth: 70, minWidth: 20),
                              child: Center(
                                child: Text(
                                  '${player.skillRating}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: BackgroundBlack,
    );
  }

  Color _getSkillRatingColor(int skillRating) {
    double ratio = skillRating / 100.0;
    int red = (255 * (1 - ratio)).toInt();
    int green = (255 * ratio).toInt();
    return Color.fromARGB(255, red, green, 0);
  }
}