// lib/controllers/group_controller.dart
import 'package:get/get.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';

import 'group_storage_service.dart';

class GroupController extends GetxController {
  var groups = <Group>[].obs;
  final GroupStorageService _storageService = GroupStorageService();

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  Future<void> loadGroups() async {
    groups.value = await _storageService.readGroups();
  }

  Future<void> addGroup(Group group) async {
    await _storageService.createGroup(group);
    loadGroups();
  }

  Future<void> updateGroup(Group group) async {
    await _storageService.updateGroup(group);
    loadGroups();
  }

  Future<void> removeGroup(Group group) async {
    await _storageService.deleteGroup(group.id);
    loadGroups();
  }

  Future<void> addPlayerToGroup(Player player) async {
    await _storageService.createPlayer(player);
    loadGroups();
  }

  Future<void> updatePlayer(Player player) async {
    await _storageService.updatePlayer(player);
    loadGroups();
  }

  Future<void> removePlayerFromGroup(Player player) async {
    await _storageService.deletePlayer(player.id);
    loadGroups();
  }

  Future<void> removeCheckedPlayers(Group group) async {
    final players = await _storageService.getPlayersByGroupId(group.id);
    final playersToRemove = players.where((player) => player.isChecked).toList();

    for (var player in playersToRemove) {
      await _storageService.deletePlayer(player.id);
    }

    loadGroups();
  }

  Future<void> updatePlayerCheckedState(Player player) async {
    await _storageService.updatePlayer(player);
    loadGroups();
  }

  Future<List<Player>> getPlayersByGroupId(String groupId) async {
    return await _storageService.getPlayersByGroupId(groupId);
  }
}