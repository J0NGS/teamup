import 'package:flutter/material.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/utils/colors.dart';

class TeamResultScreen extends StatelessWidget {
  final List<List<Player>> teams;

  TeamResultScreen({required this.teams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Times Sorteados', style: TextStyle(color: Colors.white)),
        backgroundColor: Black100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            final totalSkillRating = team.fold(0, (sum, player) => sum + player.skillRating);
            final averageSkillRating = team.isNotEmpty ? totalSkillRating / team.length : 0;

            return Card(
              color: Black100,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time ${index + 1}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      'Maior Nota: ${team.map((p) => p.skillRating).reduce((a, b) => a > b ? a : b)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Média de Nota: ${averageSkillRating.toStringAsFixed(1)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    ...team.map((player) => Text(
                      '${player.name} - ${player.skillRating} - ${player.position}',
                      style: TextStyle(color: Colors.white),
                    )).toList(),
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
