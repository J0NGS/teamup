import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:teamup/models/team.dart';

import 'database_service.dart';

class TeamStorageService {
  static final TeamStorageService _instance = TeamStorageService._internal();
  factory TeamStorageService() => _instance;
  TeamStorageService._internal();

  Future<void> createTeam(Team team) async {
    final db = await DatabaseService().database;
    await db.insert('teams', team.toMap());
  }

  Future<List<Team>> readTeams() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query('teams');
    return List.generate(maps.length, (i) {
      return Team.fromMap(maps[i]);
    });
  }

  Future<void> updateTeam(Team team) async {
    final db = await DatabaseService().database;
    await db.update(
      'teams',
      team.toMap(),
      where: 'id = ?',
      whereArgs: [team.id],
    );
  }

  Future<void> deleteTeam(String id) async {
    final db = await DatabaseService().database;
    await db.delete(
      'teams',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Team>> searchTeamsByEventId(String eventId) async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'teams',
      where: 'event = ?',
      whereArgs: [eventId],
    );
    return List.generate(maps.length, (i) {
      return Team.fromMap(maps[i]);
    });
  }
}
