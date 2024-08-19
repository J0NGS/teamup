import 'package:flutter/material.dart';  // Importa o pacote Flutter Material para criar widgets e temas
import 'package:teamup/models/player.dart';  // Importa o modelo de jogador
import 'package:teamup/utils/colors.dart';  // Importa o arquivo de cores personalizado

class TeamResultScreen extends StatelessWidget {
  final List<List<Player>> teams;  // Lista de times, onde cada time é uma lista de jogadores

  TeamResultScreen({required this.teams});  // Construtor para receber a lista de times

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Times Sorteados', style: TextStyle(color: Colors.white)),  // Título da AppBar
        backgroundColor: Black100,  // Cor de fundo da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Padding ao redor do corpo da tela
        child: ListView.builder(
          itemCount: teams.length,  // Número de times a serem exibidos
          itemBuilder: (context, index) {
            final team = teams[index];  // Obtém o time atual
            final totalSkillRating = team.fold(0, (sum, player) => sum + player.skillRating);  // Calcula a soma das notas de habilidade
            final averageSkillRating = team.isNotEmpty ? totalSkillRating / team.length : 0;  // Calcula a média das notas de habilidade

            return Card(
              color: Black100,  // Cor de fundo do Card
              margin: EdgeInsets.symmetric(vertical: 8.0),  // Margem vertical do Card
              child: Padding(
                padding: const EdgeInsets.all(16.0),  // Padding dentro do Card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,  // Alinha o conteúdo do Card à esquerda
                  children: [
                    Text(
                      'Time ${index + 1}',  // Nome do time (ex: Time 1, Time 2, etc.)
                      style: TextStyle(fontSize: 20, color: Colors.white),  // Estilo do texto
                    ),
                    Text(
                      'Maior Nota: ${team.map((p) => p.skillRating).reduce((a, b) => a > b ? a : b)}',  // Maior nota de habilidade do time
                      style: TextStyle(color: Colors.white),  // Estilo do texto
                    ),
                    Text(
                      'Média de Nota: ${averageSkillRating.toStringAsFixed(1)}',  // Média das notas de habilidade do time
                      style: TextStyle(color: Colors.white),  // Estilo do texto
                    ),
                    SizedBox(height: 10),  // Espaço entre os detalhes do time e a lista de jogadores
                    ...team.map((player) => Text(
                      '${player.name} - ${player.skillRating} - ${player.position}',  // Informações do jogador (nome, nota de habilidade e posição)
                      style: TextStyle(color: Colors.white),  // Estilo do texto
                    )).toList(),  // Converte a lista de widgets Text em uma lista de widgets
                  ],
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: BackgroundBlack,  // Cor de fundo da tela
    );
  }
}
