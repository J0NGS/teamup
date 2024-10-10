import 'package:get/get.dart';
import 'package:teamup/models/goal.dart';
import 'package:teamup/services/goal_storage_service.dart';

class GoalController extends GetxController {
  var goals = <Goal>[].obs;
  final GoalStorageService _storageService = GoalStorageService();

  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  Future<Goal?> getById(String id) async {
    return goals.firstWhereOrNull((goal) => goal.id == id);
  }

  Future<void> loadGoals() async {
    goals.value = await _storageService.readGoals();
  }

  Future<void> addGoal(Goal goal) async {
    await _storageService.createGoal(goal);
    loadGoals();
  }

  Future<void> updateGoal(Goal goal) async {
    await _storageService.updateGoal(goal);
    loadGoals();
  }

  Future<void> removeGoal(String id) async {
    await _storageService.deleteGoal(id);
    loadGoals();
  }

  Future<List<Goal>> searchGoalsByMatchId(String matchId) async {
    return await _storageService.searchGoalsByMatchId(matchId);
  }
}
