import 'package:get/get.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';

import 'group_storage_service.dart';

class GroupController extends GetxController {
  var groups = <Group>[].obs;
  final GroupStorageService storageService = GroupStorageService();

  @override
  void onInit() {
    super.onInit();
    groups.assignAll(storageService.readGroups());
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
    storageService.writeGroups(groups);
  }
}