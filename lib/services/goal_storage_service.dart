import '../models/goal.dart';
import 'database_service.dart';

class GoalStorageService {
  static final GoalStorageService _instance = GoalStorageService._internal();
  factory GoalStorageService() => _instance;
  GoalStorageService._internal();

  Future<void> createGoal(Goal goal) async {
    final db = await DatabaseService().database;
    await db.insert('goals', goal.toMap());
  }

  Future<List<Goal>> readGoals() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query('goals');
    return List.generate(maps.length, (i) {
      return Goal.fromMap(maps[i]);
    });
  }

  Future<void> updateGoal(Goal goal) async {
    final db = await DatabaseService().database;
    await db.update(
      'goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<void> deleteGoal(String id) async {
    final db = await DatabaseService().database;
    await db.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Goal>> searchGoalsByMatchId(String matchId) async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'goals',
      where: 'gameId = ?',
      whereArgs: [matchId],
    );
    return List.generate(maps.length, (i) {
      return Goal.fromMap(maps[i]);
    });
  }
}
