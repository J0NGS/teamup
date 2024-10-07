import 'package:get/get.dart';
import 'package:teamup/models/team.dart';
import 'package:teamup/services/team_storage_service.dart';

class TeamController extends GetxController {
  var teams = <Team>[].obs;
  final TeamStorageService _storageService = TeamStorageService();

  @override
  void onInit() {
    super.onInit();
    loadTeams();
  }

  Future<Team?> getById(String id) async {
    return teams.firstWhereOrNull((team) => team.id == id);
  }

  Future<void> loadTeams() async {
    teams.value = await _storageService.readTeams();
  }

  Future<void> addTeam(Team team) async {
    await _storageService.createTeam(team);
    loadTeams();
  }

  Future<void> updateTeam(Team team) async {
    await _storageService.updateTeam(team);
    loadTeams();
  }

  Future<void> removeTeam(String id) async {
    await _storageService.deleteTeam(id);
    loadTeams();
  }

  Future<void> searchTeamsByEventId(String eventId) async {
    teams.value = await _storageService.searchTeamsByEventId(eventId);
  }
}
