import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/match_controller.dart';
import 'package:teamup/models/event.dart';
import 'package:teamup/models/game.dart';
import 'package:teamup/models/team.dart';
import 'package:teamup/utils/colors.dart';

class EventScreen extends StatelessWidget {
  final Event event;
  final List<Team> teams;
  final MatchController matchController = Get.put(MatchController());

  EventScreen({required this.event, required this.teams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evento', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.green),
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
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'Data: ${event.date}',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final games = matchController.matches
                  .where((game) => game.eventId == event.id)
                  .toList();
              return ListView.builder(
                itemCount: games.length + teams.length,
                itemBuilder: (context, index) {
                  if (index < games.length) {
                    final game = games[index];
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
                            'Partida ${index + 1}',
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                          Text(
                            'Time A: ${game.teamAId}',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            'Time B: ${game.teamBId}',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final team = teams[index - games.length];
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
                            'Time ${index - games.length + 1}',
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                          ...team.players.map((playerId) {
                            return Text(
                              'Jogador: $playerId',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
      backgroundColor: BackgroundBlack,
    );
  }
}
