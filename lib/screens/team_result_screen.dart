import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/event_controller.dart';
import 'package:teamup/controllers/team_controller.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/models/team.dart';
import 'package:teamup/utils/colors.dart';
import 'package:uuid/uuid.dart';

import '../controllers/event_data_modal_controller.dart';
import '../models/event.dart';
import '../widgets/event_data_modal.dart';
import 'event_screen.dart';

class TeamResultScreen extends StatelessWidget {
  final List<List<Player>> teams;
  TeamResultScreen({super.key, required this.teams});

  final EventDataController eventDataController =
      Get.put(EventDataController());

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
        title: const Text('Times Sorteados',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.green),
        backgroundColor: Black100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.dialog(EventDataModal(
                  onStart: (place, matchTime) async {
                    final String id = const Uuid().v4();
                    final DateTime now = DateTime.now();
                    final Event event = Event(
                      id: id,
                      place: place,
                      matchTime: matchTime,
                      date: now,
                      groupId: teams.first.first.groupId,
                    );

                    final EventController eventController =
                        Get.put(EventController());
                    await eventController.addEvent(event);

                    final TeamController teamController =
                        Get.put(TeamController());
                    final List<Team> teamModels = [];
                    for (var team in teams) {
                      final teamId = const Uuid().v4();
                      final teamModel = Team(
                        id: teamId,
                        players: team.map((player) => player.id).toList(),
                        eventId: event.id,
                      );
                      await teamController.addTeam(teamModel);
                      teamModels.add(teamModel);
                    }

                    Get.to(() => EventScreen(event: event, teams: teamModels));
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Começar evento com times sorteados',
                style: TextStyle(color: Black100),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  final team = teams[index];
                  final averageRating =
                      team.map((p) => p.skillRating).reduce((a, b) => a + b) /
                          team.length;
                  final highestRating = team
                      .map((p) => p.skillRating)
                      .reduce((a, b) => a > b ? a : b);

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
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                          Text(
                            'Maior Nota: $highestRating',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                          const SizedBox(height: 10),
                          ...team.map((player) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${player.name} - ${player.position} - V:${player.speed} - M:${player.movement} - F:${player.phase}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: _getSkillRatingColor(
                                          player.skillRating),
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
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: BackgroundBlack,
    );
  }
}
