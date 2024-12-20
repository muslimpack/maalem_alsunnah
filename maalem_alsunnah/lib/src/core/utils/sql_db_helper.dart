import 'dart:async';
import 'dart:io';

import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlDBHelper {
  late final String dbName;
  late final int dbVersion;

  SqlDBHelper({required this.dbName, required this.dbVersion}) {
    appPrint("SqlDBHelper for $dbName");
  }

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

  /// Loads the .sql file and executes it using a "cursor-like" approach
  Future<void> executeSqlFromAssetsCursor(
    Database db,
    String sqlAssetPath,
  ) async {
    appPrint("Loading SQL file $sqlAssetPath...");

    try {
      // Load the SQL file from assets
      final ByteData data = await rootBundle.load(sqlAssetPath);
      final String sql = String.fromCharCodes(data.buffer.asUint8List());

      // Use a batch for cursor-like execution of SQL commands
      final Batch batch = db.batch();

      for (final cmd in sql.split(";")) {
        appPrint(cmd);
        batch.execute(cmd);
      }

      // Commit the batch (executing all the commands)
      await batch.commit(noResult: true); // Use noResult to reduce memory usage

      appPrint("SQL batch execution done");
    } catch (e) {
      appPrint("SQL batch execution failed: $e");
    }
  }

  Future<Database> initDatabase() async {
    appPrint("$dbName init db");
    final String path = await getDbPath();
    final bool exist = await databaseExists(path);

    final fileName = dbName.split(".").first;

    final Database resultDB;
    if (!exist) {
      // If the database does not exist, create it by executing the SQL file
      appPrint("$dbName does not exist, creating new db...");
      resultDB = await openDatabase(
        path,
        version: dbVersion,
        onCreate: (db, version) async {
          await executeSqlFromAssetsCursor(db, 'assets/db/$fileName.sql');
        },
      );
    } else {
      // If the database exists, open it
      final db = await openDatabase(path);

      final currentVersion = await db.getVersion();

      if (currentVersion < dbVersion) {
        appPrint("$dbName detect new version");
        await deleteDatabase(path);
        resultDB = await openDatabase(
          path,
          version: dbVersion,
          onCreate: (db, version) async {
            await executeSqlFromAssetsCursor(db, 'assets/db/$fileName.sql');
          },
        );
      } else {
        resultDB = db;
      }
    }

    return resultDB;
  }
}
