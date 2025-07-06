import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/saved_meal.dart';

class MealDatabase {
  static Database? _instance;

  Future<Database> get _db async {
    if (_instance != null) return _instance!;
    _instance = await _init();
    return _instance!;
  }

  // ───────────────────────── DB bootstrap ──────────────────────────
  Future<Database> _init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'meals.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, _) async => _createSchema(db),
      onUpgrade: (db, oldV, newV) async {
        // v1 → v2: just recreate the recent_meals table (small & cache‑like)
        if (oldV < 2) {
          await db.execute('DROP TABLE IF EXISTS recent_meals;');
          await _createRecent(db);
        }
      },
    );
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE saved_meals (
        name TEXT PRIMARY KEY,
        image TEXT,
        calories TEXT
      );
    ''');

    await _createRecent(db);
  }

  Future<void> _createRecent(Database db) async => db.execute('''
      CREATE TABLE recent_meals (
        name TEXT PRIMARY KEY,
        image TEXT,
        calories TEXT
        -- implicit rowid is used for ordering
      );
    ''');

  // ───────────────────── Saved‑meals CRUD ──────────────────────────
  Future<List<SavedMeal>> getAllSaved() async {
    final db = await _db;
    final rows = await db.query('saved_meals');
    return rows.map(SavedMeal.fromJson).toList();
  }

  Future<void> addSaved(SavedMeal meal) async {
    final db = await _db;
    await db.insert(
      'saved_meals',
      meal.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeSaved(String name) async {
    final db = await _db;
    await db.delete('saved_meals', where: 'name = ?', whereArgs: [name]);
  }

  Future<bool> savedExists(String name) async {
    final db = await _db;
    final res = await db.query(
      'saved_meals',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  // ──────────────── Recently‑viewed CRUD (keep 10) ─────────────────
  Future<void> upsertRecent(SavedMeal meal, {int keep = 10}) async {
    final db = await _db;

    // 1. Insert or replace; REPLACE gives existing row a new rowid → "most recent".
    await db.insert(
      'recent_meals',
      meal.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 2. Trim table to the newest `keep` rows.
    await db.delete(
      'recent_meals',
      where:
          'rowid NOT IN (SELECT rowid FROM recent_meals ORDER BY rowid DESC LIMIT ?)',
      whereArgs: [keep],
    );
  }

  Future<List<SavedMeal>> getRecent() async {
    final db = await _db;
    final rows = await db.query(
      'recent_meals',
      orderBy: 'rowid DESC',
    ); // newest first
    return rows.map(SavedMeal.fromJson).toList();
  }

  Future<void> clearRecent() async {
    final db = await _db;
    await db.delete('recent_meals');
  }
}
