import 'package:teamup/models/event.dart';

import 'database_service.dart';

class EventStorageService {
  static final EventStorageService _instance = EventStorageService._internal();
  factory EventStorageService() => _instance;
  EventStorageService._internal();

  Future<void> createEvent(Event event) async {
    final db = await DatabaseService().database;
    await db.insert('events', event.toMap());
  }

  Future<List<Event>> readEvents() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  Future<void> updateEvent(Event event) async {
    final db = await DatabaseService().database;
    await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(String id) async {
    final db = await DatabaseService().database;
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Event>> searchEventByGroupId(String groupId) async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );
    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }
}
