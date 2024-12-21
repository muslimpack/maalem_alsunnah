import 'dart:async';
import 'dart:io';

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

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
