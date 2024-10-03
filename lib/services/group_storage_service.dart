import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teamup/models/group.dart';

class GroupStorageService {
  static final GroupStorageService _instance = GroupStorageService._internal();
  factory GroupStorageService() => _instance;
  GroupStorageService._internal();

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
          CREATE TABLE groups(
            id TEXT PRIMARY KEY,
            name TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> createGroup(Group group) async {
    final db = await database;
    await db.insert('groups', group.toMap());
  }

  Future<List<Group>> readGroups() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('groups');
    return List.generate(maps.length, (i) {
      return Group.fromMap(maps[i]);
    });
  }

  Future<void> updateGroup(Group group) async {
    final db = await database;
    await db.update(
      'groups',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  Future<void> deleteGroup(String id) async {
    final db = await database;
    await db.delete(
      'groups',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
