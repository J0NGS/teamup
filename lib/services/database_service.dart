import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

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
      version: 1,
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
        await db.execute('''
          CREATE TABLE events(
            id TEXT PRIMARY KEY,
            date TEXT,
            matchTime TEXT,
            place TEXT,
            groupId TEXT,
            FOREIGN KEY(groupId) REFERENCES groups(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE goals(
            id TEXT PRIMARY KEY,
            playerId TEXT,
            teamId TEXT,
            gameId TEXT,
            time TEXT,
            FOREIGN KEY(playerId) REFERENCES players(id),
            FOREIGN KEY(teamId) REFERENCES teams(id),
            FOREIGN KEY(gameId) REFERENCES games(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE games(
            id TEXT PRIMARY KEY,
            teamAId TEXT,
            teamBId TEXT,
            eventId TEXT,
            FOREIGN KEY(teamAId) REFERENCES teams(id),
            FOREIGN KEY(teamBId) REFERENCES teams(id),
            FOREIGN KEY(eventId) REFERENCES events(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE teams(
            id TEXT PRIMARY KEY,
            players TEXT,
            eventId TEXT,
            FOREIGN KEY(eventId) REFERENCES events(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE groups(
            id TEXT PRIMARY KEY,
            name TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {}
      },
    );
  }
}
