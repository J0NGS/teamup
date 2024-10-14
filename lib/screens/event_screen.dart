import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/match_controller.dart';
import 'package:teamup/models/event.dart';
import 'package:teamup/models/team.dart';
import 'package:teamup/utils/colors.dart';
import 'package:teamup/controllers/player_controller.dart';
import '../controllers/goal_controller.dart';
import '../models/game.dart';
import '../models/goal.dart';
import 'register_match_screen.dart';

class EventScreen extends StatelessWidget {
  final Event event;
  final List<Team> teams;
  final MatchController matchController = Get.put(MatchController());
  final PlayerController playerController = Get.put(PlayerController());
  final GoalController goalController = Get.put(GoalController());

  EventScreen({super.key, required this.event, required this.teams});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

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
                        final RxBool isExpanded = false.obs;
                        return Obx(() {
                          return Stack(
                            children: [
                              if (isExpanded.value)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Black100,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Partida ${games.indexOf(game) + 1}',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Time ${teams.indexWhere((team) => team.id == game.teamAId) + 1}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            FutureBuilder(
                                              future: goalController
                                                  .searchGoalsByMatchId(
                                                      game.id),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text(
                                                    'Carregando gols...',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return const Text(
                                                    'Erro ao carregar gols',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14),
                                                  );
                                                } else if (snapshot.hasData) {
                                                  final goals = snapshot.data
                                                      as List<Goal>;
                                                  final teamAGoals = goals
                                                      .where((goal) =>
                                                          goal.teamId ==
                                                          game.teamAId)
                                                      .length;
                                                  return Text(
                                                    '$teamAGoals',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                } else {
                                                  return const Text(
                                                    '0',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(5.0)),
                                        Column(
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0)),
                                            Text(
                                              'X',
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                isExpanded.value =
                                                    !isExpanded.value;
                                              },
                                              child: Text(
                                                isExpanded.value
                                                    ? 'ver menos'
                                                    : 'ver mais',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0)),
                                        Column(
                                          children: [
                                            Text(
                                              'Time ${teams.indexWhere((team) => team.id == game.teamBId) + 1}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            FutureBuilder(
                                              future: goalController
                                                  .searchGoalsByMatchId(
                                                      game.id),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text(
                                                    'Carregando gols...',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return const Text(
                                                    'Erro ao carregar gols',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14),
                                                  );
                                                } else if (snapshot.hasData) {
                                                  final goals = snapshot.data
                                                      as List<Goal>;
                                                  final teamBGoals = goals
                                                      .where((goal) =>
                                                          goal.teamId ==
                                                          game.teamBId)
                                                      .length;
                                                  return Text(
                                                    '$teamBGoals',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                } else {
                                                  return const Text(
                                                    '0',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    if (isExpanded.value)
                                      FutureBuilder(
                                        future: goalController
                                            .searchGoalsByMatchId(game.id),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Text(
                                              'Carregando detalhes...',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text(
                                              'Erro ao carregar detalhes',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            );
                                          } else if (snapshot.hasData) {
                                            final goals =
                                                snapshot.data as List<Goal>;
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: goals
                                                      .where((goal) =>
                                                          goal.teamId ==
                                                          game.teamAId)
                                                      .map((goal) {
                                                    return FutureBuilder(
                                                      future: playerController
                                                          .getById(
                                                              goal.playerId),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Text(
                                                            'Carregando jogador...',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return const Text(
                                                            'Erro ao carregar jogador',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 14),
                                                          );
                                                        } else if (snapshot
                                                            .hasData) {
                                                          final player =
                                                              snapshot.data;
                                                          return Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .sports_soccer,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                player!.name,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              const Icon(
                                                                Icons
                                                                    .access_time,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                formatDuration(
                                                                    goal.time),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return const Text(
                                                            'Jogador não encontrado',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 14),
                                                          );
                                                        }
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                                const SizedBox(
                                                    width:
                                                        50),
                                                Column(
                                                  children: goals
                                                      .where((goal) =>
                                                          goal.teamId ==
                                                          game.teamBId)
                                                      .map((goal) {
                                                    return FutureBuilder(
                                                      future: playerController
                                                          .getById(
                                                              goal.playerId),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Text(
                                                            'Carregando jogador...',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return const Text(
                                                            'Erro ao carregar jogador',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 14),
                                                          );
                                                        } else if (snapshot
                                                            .hasData) {
                                                          final player =
                                                              snapshot.data;
                                                          return Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .sports_soccer,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                player!.name,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              const Icon(
                                                                Icons
                                                                    .access_time,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                formatDuration(
                                                                    goal.time),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return const Text(
                                                            'Jogador não encontrado',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 14),
                                                          );
                                                        }
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const Text(
                                              'Nenhum detalhe encontrado',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            );
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
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
