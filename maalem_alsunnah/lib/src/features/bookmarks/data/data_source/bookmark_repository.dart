import 'dart:async';
import 'dart:io';

import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_model.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BookmarkRepository {
  ///|*| ************* Variables ************* *|

  static const String dbName = "bookmarks.db";
  static const int dbVersion = 1;

  static BookmarkRepository? _databaseHelper;
  static Database? _database;

  ///|*| ************* Singleton Constructor ************* *|
  factory BookmarkRepository() {
    _databaseHelper ??= BookmarkRepository._createInstance();
    return _databaseHelper!;
  }

  BookmarkRepository._createInstance();

  Future<Database> get database async {
    if (_database == null || !(_database?.isOpen ?? false)) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  ///|*| ************* Database Creation ************* *|
  ///MARK: Database Creation
  Future<String> getDbPath() async {
    late final String path;

    if (Platform.isWindows) {
      final dbPath = (await getApplicationSupportDirectory()).path;
      path = join(dbPath, dbName);
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, dbName);
    }

    return path;
  }

  /// init
  Future<Database> _initDatabase() async {
    final String path = await getDbPath();

    final Database db = await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreateDatabase,
      onUpgrade: _onUpgradeDatabase,
      onDowngrade: _onDowngradeDatabase,
    );

    return db;
  }

  /// On create database
  Future<void> _onCreateDatabase(Database db, int version) async {
    /// Create bookmark table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS bookmarks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      itemId INTEGER NOT NULL,
      type TEXT NOT NULL,
      isBookmarked INTEGER NOT NULL,
      isRead INTEGER NOT NULL,
      note TEXT NOT NULL,
      addedDate INTEGER NOT NULL,
      updateDate INTEGER NOT NULL
    );
    ''');
  }

  /// On upgrade database version
  void _onUpgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) {}

  /// On downgrade database version
  void _onDowngradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) {}

  ///|*| ************* ********* ************* |
  ///|*| ************* Functions ************* |
  ///|*| ************* ********* ************* |
  ///MARK: Functions

  // Add or update bookmark
  Future<int> addOrUpdateBookmark({
    required BookmarkModel bookmark,
  }) async {
    final Database db = await database;
    // Update existing bookmark
    return db.insert(
      'bookmarks',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete bookmark
  Future<void> deleteBookmark(
      {required int itemId, required BookmarkType type}) async {
    final Database db = await database;

    await db.delete(
      'bookmarks',
      where: 'itemId = ? AND type = ?',
      whereArgs: [itemId, type.name],
    );
  }

  // Get all bookmarks
  Future<List<BookmarkModel>> getBookmarks() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');
    return List.generate(maps.length, (i) => BookmarkModel.fromMap(maps[i]));
  }

  // Check if item is bookmarked
  Future<BookmarkModel?> isExist({
    required int itemId,
    required BookmarkType type,
  }) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'bookmarks',
      where: 'itemId = ? AND type = ?',
      whereArgs: [itemId, type.name],
    );

    return List.generate(maps.length, (i) => BookmarkModel.fromMap(maps[i]))
        .firstOrNull;
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
