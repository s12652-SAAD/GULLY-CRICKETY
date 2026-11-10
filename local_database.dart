import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._();
  static final LocalDatabase instance = LocalDatabase._();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'gully_cricket.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE teams(
          id TEXT PRIMARY KEY, name TEXT NOT NULL, created_at TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE players(
          id TEXT PRIMARY KEY, team_id TEXT, name TEXT NOT NULL,
          role TEXT, created_at TEXT NOT NULL,
          FOREIGN KEY(team_id) REFERENCES teams(id)
        )
      ''');
      await db.execute('''
        CREATE TABLE matches(
          id TEXT PRIMARY KEY, team_a TEXT NOT NULL, team_b TEXT NOT NULL,
          overs INTEGER NOT NULL, format TEXT NOT NULL, venue TEXT,
          status TEXT NOT NULL, winner TEXT, result TEXT,
          created_at TEXT NOT NULL, completed_at TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE deliveries(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          match_id TEXT NOT NULL, innings INTEGER NOT NULL,
          sequence INTEGER NOT NULL, batter_runs INTEGER NOT NULL,
          total_runs INTEGER NOT NULL, extra_type TEXT NOT NULL,
          extra_runs INTEGER NOT NULL, legal INTEGER NOT NULL,
          wicket INTEGER NOT NULL, wicket_type TEXT,
          striker_id TEXT NOT NULL, bowler_id TEXT NOT NULL,
          dismissed_player_id TEXT, completed_runs INTEGER NOT NULL,
          FOREIGN KEY(match_id) REFERENCES matches(id)
        )
      ''');
      await db.execute('''
        CREATE TABLE awards(
          id INTEGER PRIMARY KEY AUTOINCREMENT, match_id TEXT NOT NULL,
          player_id TEXT NOT NULL, award_name TEXT NOT NULL,
          reason TEXT, confirmed_manually INTEGER NOT NULL DEFAULT 0
        )
      ''');
    });
    return _db!;
  }

  Future<void> saveDelivery(String matchId, int innings, Map<String, Object?> row) async {
    final db = await database;
    await db.insert('deliveries', row);
  }

  Future<List<Map<String, Object?>>> matchHistory() async {
    final db = await database;
    return db.query('matches', orderBy: 'created_at DESC');
  }
}
