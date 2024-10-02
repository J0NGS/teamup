import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/utils/colors.dart';

import 'ScoreBoardScreen.dart';

class TeamResultScreen extends StatelessWidget {
  final List<List<Player>> teams;
  TeamResultScreen({required this.teams});

  Color _getSkillRatingColor(int skillRating) {
    double ratio = skillRating / 100.0;
    int red = (255 * (1 - ratio)).toInt();
    int green = (255 * ratio).toInt();
    return Color.fromARGB(255, red, green, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Times Sorteados', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Black100,
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow, color: Colors.green),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => ScoreboardSettingsModal(),
                backgroundColor: Black100,
                isScrollControlled: true,
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
            final averageRating =
                team.map((p) => p.skillRating).reduce((a, b) => a + b.value) /
                    team.length;
            final highestRating = team
                .map((p) => p.skillRating)
                .reduce((a, b) => a > b.value ? a : b);

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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: _getSkillRatingColor(
                                    player.skillRating.value),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              constraints: const BoxConstraints(
                                  maxWidth: 70, minWidth: 20),
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
}

class ScoreboardSettingsModal extends StatelessWidget {
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Configurações do Placar',
              style: TextStyle(color: Colors.green, fontSize: 20)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minutesController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Minutos',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _secondsController,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Segundos',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  final int minutes =
                      int.tryParse(_minutesController.text) ?? 0;
                  final int seconds =
                      int.tryParse(_secondsController.text) ?? 0;
                  final int totalSeconds = (minutes * 60) + seconds;
                  if (totalSeconds > 0) {
                    Get.to(() => ScoreboardScreen(timer: totalSeconds));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Continuar',
                    style: TextStyle(color: Colors.black)),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
