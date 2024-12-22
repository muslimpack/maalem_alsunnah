import 'dart:async';
import 'dart:io';

import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_model.dart';
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
    CREATE TABLE IF NOT EXISTS bookmarks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titleId INTEGER ,
      hadithId INTEGER ,
      isBookmarked INTEGER NOT NULL,
      isRead INTEGER NOT NULL,
      addedDate INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
      updateDate INTEGER DEFAULT (strftime('%s', 'now')) NOT NULL
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
  Future<void> bookmarkItem({
    int? titleId,
    int? hadithId,
    required bool isBookmarked,
  }) async {
    final Database db = await database;

    await db.insert(
      'bookmarks',
      {
        'titleId': titleId,
        'hadithId': hadithId,
        'isBookmarked': isBookmarked ? 1 : 0,
        'updateDate': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Mark item as read
  Future<void> markAsRead({
    int? titleId,
    int? hadithId,
    required bool isRead,
  }) async {
    final Database db = await database;

    await db.update(
      'bookmarks',
      {
        'isRead': isRead ? 1 : 0,
        'updateDate': DateTime.now().toIso8601String(),
      },
      where:
          '(titleId = ? OR hadithId = ?) AND (titleId IS NOT NULL OR hadithId IS NOT NULL)',
      whereArgs: [titleId, hadithId],
    );
  }

  // Add or update a note
  Future<void> addNote({
    int? titleId,
    int? hadithId,
    required String note,
  }) async {
    final Database db = await database;

    await db.update(
      'bookmarks',
      {
        'note': note,
        'updateDate': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
      where:
          '(titleId = ? OR hadithId = ?) AND (titleId IS NOT NULL OR hadithId IS NOT NULL)',
      whereArgs: [titleId, hadithId],
    );
  }

  // Get all bookmarks
  Future<List<BookmarkModel>> getBookmarks() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');
    return List.generate(maps.length, (i) => BookmarkModel.fromMap(maps[i]));
  }

  // Check if item is bookmarked
  Future<bool> isBookmarked({int? titleId, int? hadithId}) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'bookmarks',
      where: '(titleId = ? OR hadithId = ?) AND isBookmarked = 1',
      whereArgs: [titleId, hadithId],
    );
    return result.isNotEmpty;
  }

  // Check if item is read
  Future<bool> isRead({int? titleId, int? hadithId}) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'bookmarks',
      where: '(titleId = ? OR hadithId = ?) AND isRead = 1',
      whereArgs: [titleId, hadithId],
    );
    return result.isNotEmpty;
  }

  // Get note for item
  Future<String?> getNote({int? titleId, int? hadithId}) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'bookmarks',
      columns: ['note'],
      where: '(titleId = ? OR hadithId = ?)',
      whereArgs: [titleId, hadithId],
    );
    return result.isNotEmpty ? result.first['note'] as String : null;
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
