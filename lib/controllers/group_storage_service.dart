import 'package:sqflite/sqflite.dart';
import 'package:teamup/models/group.dart';
import 'package:teamup/models/player.dart';
import 'package:teamup/services/database_service.dart';

class GroupStorageService {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Group>> readGroups() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> groupMaps = await db.query('groups');
    final List<Map<String, dynamic>> playerMaps = await db.query('players');

    return groupMaps.map((groupMap) {
      final groupPlayers = playerMaps
          .where((playerMap) => playerMap['groupId'] == groupMap['id'])
          .map((playerMap) => Player(
        id: playerMap['id'],
        name: playerMap['name'],
        position: playerMap['position'],
        skillRating: playerMap['skillRating'],
        speed: playerMap['speed'],
        phase: playerMap['phase'],
        movement: playerMap['movement'],
        photoUrl: playerMap['photoUrl'],
        isChecked: playerMap['isChecked'] == 1,
      ))
          .toList();

      return Group(
        id: groupMap['id'],
        name: groupMap['name'],
        players: groupPlayers,
      );
    }).toList();
  }

  Future<void> writeGroups(List<Group> groups) async {
    final db = await _databaseService.database;
    await db.transaction((txn) async {
      await txn.delete('groups');
      await txn.delete('players');

      for (var group in groups) {
        await txn.insert('groups', {
          'id': group.id,
          'name': group.name,
        });

        for (var player in group.players) {
          await txn.insert('players', {
            'id': player.id,
            'name': player.name,
            'position': player.position,
            'skillRating': player.skillRating,
            'speed': player.speed,
            'phase': player.phase,
            'movement': player.movement,
            'photoUrl': player.photoUrl,
            'isChecked': player.isChecked ? 1 : 0,
            'groupId': group.id,
          });
        }
      }
    });
  }
}