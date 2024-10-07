import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/match_controller.dart';
import 'package:teamup/models/event.dart';
import 'package:teamup/models/team.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/controllers/player_controller.dart';
import 'register_match_screen.dart';

class EventScreen extends StatelessWidget {
  final Event event;
  final List<Team> teams;
  final MatchController matchController = Get.put(MatchController());
  final PlayerController playerController = Get.put(PlayerController());

  EventScreen({super.key, required this.event, required this.teams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evento', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.green),
        backgroundColor: Black100,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Local: ${event.place}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'Data: ${event.formattedDate}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final games = matchController.matches
                  .where((game) => game.eventId == event.id)
                  .toList();
              return ListView(
                children: [
                  // Teams Section
                  ...teams.map((team) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Black100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time ${teams.indexOf(team) + 1}',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 16),
                          ),
                          ...team.players.map((playerId) {
                            return FutureBuilder(
                              future: playerController.getById(playerId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text(
                                    'Carregando...',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text(
                                    'Erro ao carregar jogador',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14),
                                  );
                                } else if (snapshot.hasData) {
                                  final player = snapshot.data;
                                  return Text(
                                    'Jogador: ${player!.name}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  );
                                } else {
                                  return const Text(
                                    'Jogador não encontrado',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14),
                                  );
                                }
                              },
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                  // Divider
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: Colors.green, thickness: 2),
                  ),
                  // Games Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Partidas',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Get.to(() => RegisterMatchScreen(
                              event: event,
                              teams: teams,
                            ));
                        matchController.loadMatches();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Começar uma partida'),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: games.map((game) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Black100,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Partida ${games.indexOf(game) + 1}',
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 16),
                              ),
                              Text(
                                'Time A: ${game.teamAId}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                'Time B: ${game.teamBId}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
      backgroundColor: BackgroundBlack,
    );
  }
}
