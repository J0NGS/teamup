import 'package:get/get.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'group_storage_service.dart';

class GroupController extends GetxController {
  var groups = <Group>[].obs;
  final GroupStorageService storageService = GroupStorageService();

  @override
  void onInit() async {
    super.onInit();
    groups.assignAll(await storageService.readGroups());
  }

  Future<void> addGroup(Group group) async {
    groups.add(group);
    await _saveToStorage();
  }

  Future<void> removeGroup(Group group) async {
    groups.remove(group);
    await _saveToStorage();
  }

  Future<void> addPlayerToGroup(Group group, Player player) async {
    final index = groups.indexWhere((g) => g.name == group.name);
    if (index != -1) {
      groups[index].players.add(player);
      groups.refresh();
      await _saveToStorage();
      print('Player added: ${player.name} to group: ${group.name}');
    } else {
      print('Group not found: ${group.name}');
    }
  }

  Future<void> updatePlayerCheckedState(Group group, Player player) async {
    final index = groups.indexWhere((g) => g.name == group.name);
    if (index != -1) {
      final playerIndex = groups[index].players.indexWhere((p) => p.name == player.name);
      if (playerIndex != -1) {
        groups[index].players[playerIndex].isChecked = player.isChecked;
        await _saveToStorage();
      }
    }
  }

  Future<void> removeCheckedPlayers(Group group) async {
    final index = groups.indexWhere((g) => g.name == group.name);
    if (index != -1) {
      groups[index].players.removeWhere((p) => p.isChecked);
      await _saveToStorage();
    }
  }

  Future<void> updatePlayer(Group group, Player updatedPlayer) async {
    final index = groups.indexWhere((g) => g.name == group.name);
    if (index != -1) {
      final playerIndex = groups[index].players.indexWhere((p) => p.name == updatedPlayer.name);
      if (playerIndex != -1) {
        groups[index].players[playerIndex] = updatedPlayer;
        await _saveToStorage();
      }
    }
  }

  Future<void> _saveToStorage() async {
    await storageService.writeGroups(groups);
  }
}