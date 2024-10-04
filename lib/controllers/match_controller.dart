import 'package:get/get.dart';
import 'package:teamup/models/game.dart';
import 'package:teamup/services/match_storage_service.dart';

class MatchController extends GetxController {
  var matches = <Game>[].obs;
  final MatchStorageService _storageService = MatchStorageService();

  @override
  void onInit() {
    super.onInit();
    loadMatches();
  }

  Future<void> loadMatches() async {
    matches.value = await _storageService.readMatches();
  }

  Future<void> addMatch(Game game) async {
    await _storageService.createMatch(game);
    loadMatches();
  }

  Future<void> updateMatch(Game game) async {
    await _storageService.updateMatch(game);
    loadMatches();
  }

  Future<void> removeMatch(String id) async {
    await _storageService.deleteMatch(id);
    loadMatches();
  }

  Future<void> searchMatchByEventId(String eventId) async {
    matches.value = await _storageService.searchMatchByEventId(eventId);
  }
}
