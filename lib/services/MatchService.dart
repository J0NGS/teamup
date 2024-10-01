import 'package:sqflite/sqflite.dart';
import 'package:teamup/models/Match.dart';
import 'package:teamup/services/database_service.dart';

class MatchService {
  final DatabaseService _databaseService = DatabaseService();

  Future<void> createMatch(Match match) async {
    final db = await _databaseService.database;
    await db.insert('matches', {
      'id': match.id,
      'date': match.date,
      'goalIds': match.goalIds.join(','),
    });
  }

  Future<List<Match>> getMatches() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('matches');
    return List.generate(maps.length, (i) {
      return Match(
        id: maps[i]['id'],
        date: maps[i]['date'],
        goalIds: maps[i]['goalIds'].split(','),
      );
    });
  }

  Future<void> updateMatch(Match match) async {
    final db = await _databaseService.database;
    await db.update(
      'matches',
      {
        'date': match.date,
        'goalIds': match.goalIds.join(','),
      },
      where: 'id = ?',
      whereArgs: [match.id],
    );
  }

  Future<void> deleteMatch(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'matches',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}