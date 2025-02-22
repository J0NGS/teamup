import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:teamup/services/player_storage_service.dart';
import '../models/player.dart';

class PlayerController extends GetxController {
  var players = <Player>[].obs;
  final PlayerStorageService _storageService = PlayerStorageService();

  var name = ''.obs;
  var selectedPosition = 'Atacante'.obs;
  var skillRating = 0.obs;
  var speed = 1.obs;
  var phase = 1.obs;
  var movement = 1.obs;
  var photoUrl = ''.obs;
  var isChecked = false.obs;

  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      name.value = nameController.text;
    });
  }

  void setName(String value) {
    name.value = value;
    nameController.text = value;
  }

  void setSelectedPosition(String value) => selectedPosition.value = value;
  void setSkillRating(int value) => skillRating.value = value;
  void setSpeed(int value) => speed.value = value;
  void setPhase(int value) => phase.value = value;
  void setMovement(int value) => movement.value = value;
  void setPhotoUrl(String value) => photoUrl.value = value;
  void setIsChecked(bool value) => isChecked.value = value;

  Future<Player?> getById(String id) async {
    return players.firstWhereOrNull((player) => player.id == id);
  }

  Future<void> loadPlayers(String groupId) async {
    players.value = await _storageService.getPlayersByGroupId(groupId);
  }

  Future<void> addPlayer(Player player) async {
    await _storageService.createPlayer(player);
    loadPlayers(player.groupId);
  }

  Future<void> updatePlayer(Player player) async {
    await _storageService.updatePlayer(player);
    loadPlayers(player.groupId);
  }

  Future<void> removePlayer(Player player) async {
    await _storageService.deletePlayer(player.id);
    loadPlayers(player.groupId);
  }

  Future<void> removeCheckedPlayers(String groupId) async {
    final playersToRemove =
        players.where((player) => player.isChecked).toList();
    for (var player in playersToRemove) {
      await _storageService.deletePlayer(player.id);
    }
    loadPlayers(groupId);
  }

  Future<void> updatePlayerCheckedState(Player player) async {
    player.isChecked = !player.isChecked;
    await _storageService.updatePlayer(player);
    loadPlayers(player.groupId);
  }
}
