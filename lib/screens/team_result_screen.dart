import 'package:flutter/material.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/utils/colors.dart';
class TeamResultScreen extends StatelessWidget {
  final List<List<Player>> teams;
  TeamResultScreen({required this.teams});  // Construtor para receber a lista de times

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Times Sorteados', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Black100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: teams.length,  // times a serem exibidos
          itemBuilder: (context, index) {
            final team = teams[index];  // time atual
            final totalSkillRating = team.fold(0, (sum, player) => sum + player.skillRating);  // soma das notas de habilidade
            final averageSkillRating = team.isNotEmpty ? totalSkillRating / team.length : 0;  // média das notas de habilidade

            return Card(
              color: Black100,
              margin: const EdgeInsets.symmetric(vertical: 8.0),  // Margem vertical do Card
              child: Padding(
                padding: const EdgeInsets.all(16.0),  // Padding dentro do Card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,  // Alinha o conteúdo do Card à esquerda
                  children: [
                    Text(
                      'Time ${index + 1}',  // Nome do time
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      'Maior Nota: ${team.map((p) => p.skillRating).reduce((a, b) => a > b ? a : b)}',  // Maior nota de habilidade do time
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Média de Nota: ${averageSkillRating.toStringAsFixed(1)}',  // Média das notas de habilidade do time
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),  // Espaço entre os detalhes do time e a lista de jogadores
                    ...team.map((player) => Text(
                      '${player.name} - ${player.position} - ${player.skillRating}',  // Informações do jogador (nome, nota de habilidade e posição)
                      style: const TextStyle(color: Colors.white),
                    )).toList(),  // Converte a lista de widgets Text em uma lista de widgets
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
