import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teamup/models/player.dart';

class PlayerStorageService {
  static final PlayerStorageService _instance =
      PlayerStorageService._internal();
  factory PlayerStorageService() => _instance;
  PlayerStorageService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'teamup.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE players(
            id TEXT PRIMARY KEY,
            name TEXT,
            position TEXT,
            skillRating INTEGER,
            speed INTEGER,
            phase INTEGER,
            movement INTEGER,
            photoUrl TEXT,
            isChecked INTEGER DEFAULT 0,
            groupId TEXT,
            FOREIGN KEY(groupId) REFERENCES groups(id)
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> createPlayer(Player player) async {
    final db = await database;
    await db.insert('players', player.toMap());
  }

  Future<List<Player>> readPlayers(String groupId) async {
    final db = await database;
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
    final db = await database;
    await db.update(
      'players',
      player.toMap(),
      where: 'id = ?',
      whereArgs: [player.id.value],
    );
  }

  Future<void> deletePlayer(String id) async {
    final db = await database;
    await db.delete(
      'players',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Player>> getPlayersByGroupId(String groupId) async {
    final db = await database;
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
