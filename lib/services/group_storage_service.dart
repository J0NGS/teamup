import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teamup/models/group.dart';

import 'database_service.dart';

class GroupStorageService {
  static final GroupStorageService _instance = GroupStorageService._internal();
  factory GroupStorageService() => _instance;
  GroupStorageService._internal();

  Future<void> createGroup(Group group) async {
    final db = await DatabaseService().database;
    await db.insert('groups', group.toMap());
  }

  Future<List<Group>> readGroups() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query('groups');
    return List.generate(maps.length, (i) {
      return Group.fromMap(maps[i]);
    });
  }

  Future<void> updateGroup(Group group) async {
    final db = await DatabaseService().database;
    await db.update(
      'groups',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  Future<void> deleteGroup(String id) async {
    final db = await DatabaseService().database;
    await db.delete(
      'groups',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
