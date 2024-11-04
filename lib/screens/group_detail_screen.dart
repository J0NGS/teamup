import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:teamup/screens/playerCreationScreen.dart';
import 'package:teamup/screens/player_edit_screen.dart';

import '../controllers/player_controller.dart';
import '../models/group.dart';
import '../models/player.dart';
import '../utils/colors.dart';
import '../widgets/team_selection_modal.dart';
import 'group_event_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

Color _getSkillRatingColor(int skillRating) {
  double ratio = skillRating / 100.0;
  int red = (255 * (1 - ratio)).toInt();
  int green = (255 * ratio).toInt();
  return Color.fromARGB(255, red, green, 0);
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _selectAll = false;
  String _sortOption = 'Nome';

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Get.put(PlayerController());

    playerController.loadPlayers(widget.group.id);

    void _filterPlayers() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    }

    void _toggleSelectAll(bool? value) {
      setState(() {
        _selectAll = value ?? false;
        playerController.players.forEach((player) {
          player.isChecked = _selectAll;
        });
      });
    }

    List<Player> _getFilteredPlayers() {
      List<Player> filteredPlayers = playerController.players
          .where((player) => player.name.toLowerCase().contains(_searchQuery))
          .toList();

      if (_sortOption == 'Nome') {
        filteredPlayers.sort((a, b) => a.name.compareTo(b.name));
      } else if (_sortOption == 'NomeDesc') {
        filteredPlayers.sort((a, b) => b.name.compareTo(a.name));
      } else if (_sortOption == 'Skill') {
        filteredPlayers.sort((a, b) => b.skillRating.compareTo(a.skillRating));
      } else if (_sortOption == 'SkillDesc') {
        filteredPlayers.sort((a, b) => a.skillRating.compareTo(b.skillRating));
      }

      return filteredPlayers;
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Grupo: ${widget.group.name}",
                style: const TextStyle(color: Colors.white))),
        backgroundColor: Black100,
        iconTheme: const IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Black100,
                    titleTextStyle: const TextStyle(color: Colors.green),
                    title: const Text('Confirmar Exclusão'),
                    content: const Text(
                      'Você tem certeza que deseja excluir os jogadores selecionados?',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar',
                            style: TextStyle(color: Colors.green)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Excluir',
                            style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          playerController
                              .removeCheckedPlayers(widget.group.id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Obx(() {
          if (playerController.players.isEmpty) {
            return Column(
              children: [
                const Padding(padding: EdgeInsets.all(5.0)),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => PlayerCreationScreen(group: widget.group))!
                        .then((result) {
                      if (result == true) {
                        playerController.loadPlayers(widget.group.id);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black87,
                  ),
                  child: const Text("Criar Jogador",
                      style: TextStyle(color: Colors.black)),
                ),
                const Spacer(),
                const Text("Nenhum jogador cadastrado",
                    style: TextStyle(color: Colors.white)),
                const Spacer(),
                const Center(),
              ],
            );
          } else {
            final players = _getFilteredPlayers();
            final selectedPlayersCount =
                players.where((p) => p.isChecked).length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => PlayerCreationScreen(group: widget.group))!
                            .then((result) {
                          if (result == true) {
                            playerController.loadPlayers(widget.group.id);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text("Criar Jogador",
                          style: TextStyle(color: Colors.black)),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(
                            () => GroupEventsScreen(groupId: widget.group.id));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text("Ver eventos do grupo",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => _filterPlayers(),
                        decoration: InputDecoration(
                          hintText: 'Pesquisar por nome',
                          hintStyle: TextStyle(color: Colors.white54),
                          prefixIcon: Icon(Icons.search, color: Colors.green),
                          filled: true,
                          fillColor: Black100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.sort_by_alpha, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          _sortOption =
                              _sortOption == 'Nome' ? 'NomeDesc' : 'Nome';
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.sort, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          _sortOption =
                              _sortOption == 'Skill' ? 'SkillDesc' : 'Skill';
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      Player player = players[index];
                      return Card(
                        color: Black100,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => PlayerEditScreen(player: player))!
                                .then((result) {
                              if (result == true) {
                                playerController.loadPlayers(widget.group.id);
                              }
                            });
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: ClipOval(
                              child: player.photoUrl.isEmpty
                                  ? const Icon(Icons.person,
                                      color: Colors.green, size: 50)
                                  : kIsWeb
                                      ? Image.network(
                                          player.photoUrl,
                                          width: 50,
                                          height: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.person,
                                                color: Colors.green, size: 50);
                                          },
                                        )
                                      : Image.file(
                                          File(player.photoUrl),
                                          width: 50,
                                          height: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.person,
                                                color: Colors.green, size: 50);
                                          },
                                        ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  player.name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: _getSkillRatingColor(
                                        player.skillRating),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  constraints: const BoxConstraints(
                                      maxWidth: 80, minWidth: 80),
                                  child: Center(
                                    child: Text(
                                      '${player.skillRating}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value: player.isChecked,
                                  activeColor: Colors.green,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      playerController
                                          .updatePlayerCheckedState(player);
                                    }
                                  },
                                ),
                              ],
                            ),
                            subtitle: const Row(
                              children: [Spacer()],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.bottomSheet(
                      TeamSelectionModal(
                          selectedPlayersCount: selectedPlayersCount,
                          group: widget.group),
                      backgroundColor: Black100,
                      isScrollControlled: true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 10),
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    alignment: Alignment.center,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Sortear Times',
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '$selectedPlayersCount jogadores selecionados',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
      backgroundColor: BackgroundBlack,
    );
  }
}
