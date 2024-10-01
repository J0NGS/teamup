import 'package:sqflite/sqflite.dart';
import 'package:teamup/models/Goal.dart';
import 'package:teamup/services/database_service.dart';

class GoalService {
  final DatabaseService _databaseService = DatabaseService();

  Future<void> createGoal(Goal goal) async {
    final db = await _databaseService.database;
    await db.insert('goals', {
      'id': goal.id,
      'playerId': goal.playerId,
      'time': goal.time,
    });
  }

  Future<List<Goal>> getGoals() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('goals');
    return List.generate(maps.length, (i) {
      return Goal(
        id: maps[i]['id'],
        playerId: maps[i]['playerId'],
        time: maps[i]['time'],
      );
    });
  }

  Future<void> updateGoal(Goal goal) async {
    final db = await _databaseService.database;
    await db.update(
      'goals',
      {
        'playerId': goal.playerId,
        'time': goal.time,
      },
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<void> deleteGoal(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}