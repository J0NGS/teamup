import 'package:teamup/models/player.dart';
import 'package:teamup/services/database_service.dart';

class PlayerStorageService {
  static final PlayerStorageService _instance =
      PlayerStorageService._internal();
  factory PlayerStorageService() => _instance;
  PlayerStorageService._internal();

  Future<void> createPlayer(Player player) async {
    final db = await DatabaseService().database;
    await db.insert('players', player.toMap());
  }

  Future<List<Player>> readPlayers(String groupId) async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'players',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );
    return List.generate(maps.length, (i) {
      return Player.fromMap(maps[i]);
    });
  }

  Future<void> updatePlayer(Player player) async {
    final db = await DatabaseService().database;
    await db.update(
      'players',
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id],
    );
  }

  Future<void> deletePlayer(String id) async {
    final db = await DatabaseService().database;
    await db.delete(
      'players',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Player>> getPlayersByGroupId(String groupId) async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'players',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );
    return List.generate(maps.length, (i) {
      return Player.fromMap(maps[i]);
    });
  }
}
