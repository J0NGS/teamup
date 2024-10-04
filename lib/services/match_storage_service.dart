import 'package:teamup/models/game.dart';

import 'database_service.dart';

class MatchStorageService {
  static final MatchStorageService _instance = MatchStorageService._internal();
  factory MatchStorageService() => _instance;
  MatchStorageService._internal();

  Future<void> createMatch(Game game) async {
    final db = await DatabaseService().database;
    await db.insert('games', game.toMap());
  }

  Future<List<Game>> readMatches() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query('games');
    return List.generate(maps.length, (i) {
      return Game.fromMap(maps[i]);
    });
  }

  Future<void> updateMatch(Game game) async {
    final db = await DatabaseService().database;
    await db.update(
      'games',
      game.toMap(),
      where: 'id = ?',
      whereArgs: [game],
    );
  }

  Future<void> deleteMatch(String id) async {
    final db = await DatabaseService().database;
    await db.delete(
      'games',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Game>> searchMatchByEventId(String eventId) async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'games',
      where: 'eventId = ?',
      whereArgs: [eventId],
    );
    return List.generate(maps.length, (i) {
      return Game.fromMap(maps[i]);
    });
  }
}
