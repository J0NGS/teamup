import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamup/controllers/match_controller.dart';
import 'package:teamup/controllers/goal_controller.dart';
import 'package:teamup/controllers/player_controller.dart';
import 'package:teamup/models/event.dart';
import 'package:teamup/models/team.dart';
import 'package:teamup/models/goal.dart';
import 'package:teamup/utils/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../models/game.dart';

class RegisterMatchScreen extends StatelessWidget {
  final Event event;
  final List<Team> teams;

  RegisterMatchScreen({super.key, required this.event, required this.teams})
      : matchTime = event.matchTime {
    elapsedTime.value = matchTime;
  }

  final MatchController matchController = Get.put(MatchController());
  final GoalController goalController = Get.put(GoalController());
  final PlayerController playerController = Get.put(PlayerController());

  final RxString selectedTeamA = ''.obs;
  final RxString selectedTeamB = ''.obs;
  final RxString selectedPlayerA = ''.obs;
  final RxString selectedPlayerB = ''.obs;
  final RxInt scoreA = 0.obs;
  final RxInt scoreB = 0.obs;
  final RxList<Goal> goals = <Goal>[].obs;
  final RxBool isPlaying = false.obs;
  final Rx<Duration> elapsedTime = Duration.zero.obs;
  final Duration matchTime;
  final RxBool _isTimerRunning = false.obs;
  Timer? _timer;

  void _startTimer() {
    if (_isTimerRunning.value) return; // Prevent multiple timers
    _isTimerRunning.value = true;
    isPlaying.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (elapsedTime.value.inSeconds > 0) {
        elapsedTime.value -= const Duration(seconds: 1);
      } else {
        _pauseTimer();
        _vibrate();
      }
    });
  }

  void _pauseTimer() {
    isPlaying.value = false;
    _isTimerRunning.value = false;
    _timer?.cancel();
  }

  void _vibrate() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate();
    }
  }

  void _showGoalDialog(BuildContext context, String message, bool isAdded) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Black100,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.all(
            10.0), // Adjust padding to make the dialog smaller
        insetPadding: const EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 24.0), // Adjust inset padding to control the size
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  void _addGoal(String teamId, String playerId) {
    if (!isPlaying.value) return;

    final goal = Goal(
      id: const Uuid().v4(),
      playerId: playerId,
      teamId: teamId,
      gameId: '', // This will be set when the match is saved
      time: matchTime - elapsedTime.value,
    );
    goals.add(goal);
    if (teamId == selectedTeamA.value) {
      scoreA.value++;
    } else {
      scoreB.value++;
    }

    final player = playerController.players.firstWhere((p) => p.id == playerId);
    _showGoalDialog(
        Get.context!, 'Gol do jogador ${player.name} adicionado', true);
  }

  void _removeLastGoal(String teamId) {
    if (goals.isNotEmpty) {
      final lastGoalIndex =
          goals.lastIndexWhere((goal) => goal.teamId == teamId);
      if (lastGoalIndex != -1) {
        final lastGoal = goals.removeAt(lastGoalIndex);
        if (lastGoal.teamId == selectedTeamA.value) {
          scoreA.value--;
        } else {
          scoreB.value--;
        }

        final player = playerController.players
            .firstWhere((p) => p.id == lastGoal.playerId);
        _showGoalDialog(
            Get.context!, 'Gol do jogador ${player.name} removido', false);
      }
    }
  }

  void _endMatch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Black100,
        title: const Text(
          'Encerrar e salvar a partida',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Tem certeza que deseja encerrar e salvar a partida?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Create a new Game object
              final game = Game(
                id: const Uuid().v4(),
                teamAId: selectedTeamA.value,
                teamBId: selectedTeamB.value,
                eventId: event.id,
                time: DateTime.now(),
              );

              // Update gameId for all goals
              final updatedGoals = goals.map((goal) {
                return Goal(
                  id: goal.id,
                  playerId: goal.playerId,
                  teamId: goal.teamId,
                  gameId: game.id,
                  time: goal.time,
                );
              }).toList();

              // Save the game
              await matchController.addMatch(game);

              // Save all goals
              for (var goal in updatedGoals) {
                await goalController.addGoal(goal);
              }

              // Close the dialog and navigate back
              Navigator.of(context).pop();
              Get.back();
            },
            child: const Text(
              'Encerrar',
              style: TextStyle(color: Colors.green),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTeamColumn(
      String teamLabel,
      RxString selectedTeam,
      RxString selectedPlayer,
      RxInt score,
      List<Team> teams,
      Function(String, String) addGoal,
      Function(String) removeLastGoal) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => DropdownButton<String>(
                value: selectedTeam.value.isEmpty ? null : selectedTeam.value,
                hint: Text('Selecione o $teamLabel',
                    style: const TextStyle(color: Colors.white)),
                dropdownColor: Black100,
                items: teams
                    .where((team) =>
                        team.id !=
                        (teamLabel == 'Time A'
                            ? selectedTeamB.value
                            : selectedTeamA.value))
                    .map((team) {
                  return DropdownMenuItem<String>(
                    value: team.id,
                    child: Text('Time ${teams.indexOf(team) + 1}',
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedTeam.value = value!;
                  selectedPlayer.value = '';
                },
              )),
          Obx(() => Text(
                '${score.value}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 70,
                    fontWeight: FontWeight.bold),
              )),
          Obx(() {
            if (selectedTeam.value.isNotEmpty) {
              final team =
                  teams.firstWhere((team) => team.id == selectedTeam.value);
              return DropdownButton<String>(
                value:
                    selectedPlayer.value.isEmpty ? null : selectedPlayer.value,
                hint: const Text('Selecione o Jogador',
                    style: TextStyle(color: Colors.white)),
                dropdownColor: Black100,
                items: team.players.map((playerId) {
                  final player = playerController.players
                      .firstWhere((p) => p.id == playerId);
                  return DropdownMenuItem<String>(
                    value: player.id,
                    child: Text(player.name,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedPlayer.value = value!;
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => removeLastGoal(selectedTeam.value),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: const Text('-'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (selectedPlayer.value.isNotEmpty) {
                    addGoal(selectedTeam.value, selectedPlayer.value);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('+'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Partida',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.green),
        backgroundColor: Black100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isPortrait
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTeamColumn('Time A', selectedTeamA, selectedPlayerA,
                      scoreA, teams, _addGoal, _removeLastGoal),
                  const SizedBox(height: 16), // Add padding between rows
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() => Text(
                            '${elapsedTime.value.inMinutes}:${(elapsedTime.value.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 36),
                          )),
                      IconButton(
                        icon: Icon(
                            isPlaying.value ? Icons.pause : Icons.play_arrow),
                        color: Colors.green,
                        onPressed: isPlaying.value ? _pauseTimer : _startTimer,
                      ),
                      ElevatedButton(
                        onPressed: () => _endMatch(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Encerrar e salvar a partida',
                          style: TextStyle(color: Black100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Add padding between rows
                  _buildTeamColumn('Time B', selectedTeamB, selectedPlayerB,
                      scoreB, teams, _addGoal, _removeLastGoal),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTeamColumn('Time A', selectedTeamA, selectedPlayerA,
                      scoreA, teams, _addGoal, _removeLastGoal),
                  const SizedBox(width: 16), // Add padding between columns
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() => Text(
                            '${elapsedTime.value.inMinutes}:${(elapsedTime.value.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 36),
                          )),
                      IconButton(
                        icon: Icon(
                            isPlaying.value ? Icons.pause : Icons.play_arrow),
                        color: Colors.green,
                        onPressed: isPlaying.value ? _pauseTimer : _startTimer,
                      ),
                      ElevatedButton(
                        onPressed: () => _endMatch(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Encerrar e salvar a partida',
                          style: TextStyle(color: Black100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16), // Add padding between columns
                  _buildTeamColumn('Time B', selectedTeamB, selectedPlayerB,
                      scoreB, teams, _addGoal, _removeLastGoal),
                ],
              ),
      ),
      backgroundColor: BackgroundBlack,
    );
  }
}
