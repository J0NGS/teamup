import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';

class GroupController extends GetxController {
  var groups = <Group>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    print("Loading groups from storage...");
    List<dynamic>? storedGroups = box.read<List<dynamic>>('grupos');
    print(storedGroups); // Verificar o que está sendo lido

    if (storedGroups != null) {
      groups.assignAll(storedGroups.map((group) => Group(
        name: group['name'],
        players: List<Player>.from(group['players'].map((player) {
          print(player['photoUrl']); // Verificar o valor do photoUrl ao carregar
          return Player(
            name: player['name'],
            position: player['position'],
            skillRating: player['skillRating'],
            speed: player['speed'],
            phase: player['phase'],
            movement: player['movement'],
            photoUrl: player['photoUrl'],
            isChecked: player['isChecked'] ?? false,
          );
        })),
      )));
    }
  }

  void addGroup(Group group) {
    groups.add(group);
    _saveToStorage();
  }

  void removeGroup(Group group) {
    groups.remove(group);
    _saveToStorage();
  }

  void addPlayerToGroup(Group group, Player player) {
    final index = groups.indexWhere((g) => g.name == group.name);
    if (index != -1) {
      groups[index].players.add(player);
      _saveToStorage();
    }
  }

  void updatePlayerCheckedState(Group group, Player player) {
    final index = groups.indexWhere((g) => g.name == group.name);
    if (index != -1) {
      final playerIndex = groups[index].players.indexWhere((p) => p.name == player.name);
      if (playerIndex != -1) {
        groups[index].players[playerIndex].isChecked = player.isChecked;
        _saveToStorage();
      }
    }
  }

  void removeCheckedPlayers(Group group) {
    final index = groups.indexWhere((g) => g.name == group.name);
    if (index != -1) {
      groups[index].players.removeWhere((p) => p.isChecked);
      _saveToStorage();
    }
  }

  void updatePlayer(Group group, Player updatedPlayer) {
    final index = groups.indexWhere((g) => g.name == group.name);
    if (index != -1) {
      final playerIndex = groups[index].players.indexWhere((p) => p.name == updatedPlayer.name);
      if (playerIndex != -1) {
        groups[index].players[playerIndex] = updatedPlayer;
        _saveToStorage();
      }
    }
  }

  void _saveToStorage() {
    print("Saving groups to storage...");
    print(groups.map((g) => g.players.map((p) => p.photoUrl).toList()).toList());

    box.write('grupos', groups.map((g) => {
      'name': g.name,
      'players': g.players.map((p) => {
        'name': p.name,
        'position': p.position,
        'skillRating': p.skillRating,
        'speed': p.speed,
        'phase': p.phase,
        'movement': p.movement,
        'photoUrl': p.photoUrl,
        'isChecked': p.isChecked,
      }).toList(),
    }).toList());
  }
}
