import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/core/utils/db_helper.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/search_type.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/sql_query.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:sqflite/sqflite.dart';

class HadithDbHelper {
  /* ************* Variables ************* */

  static const String dbName = "book.db";
  static const int dbVersion = 1;

  /* ************* Singleton Constructor ************* */

  static HadithDbHelper? _instance;
  static Database? _database;
  static late final DBHelper _dbHelper;

  factory HadithDbHelper() {
    _dbHelper = DBHelper(dbName: dbName, dbVersion: dbVersion);
    _instance ??= HadithDbHelper._createInstance();
    return _instance!;
  }

  HadithDbHelper._createInstance();

  Future<Database> get database async {
    _database ??= await _dbHelper.initDatabase();
    return _database!;
  }

  Future<void> init() async {
    // Ensure the database is initialized
    await database;
  }

  /* ************* | ************* */

  Future<List<HadithModel>> getAll() async {
    final Database db = await database;

    ///TODO |  ORDER BY `order` ASC
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM hadith');

    return List.generate(maps.length, (i) {
      return HadithModel.fromMap(maps[i]);
    });
  }

  Future<HadithModel?> getHadithById(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM hadith where id = ?', [id]);

    return List.generate(maps.length, (i) {
      return HadithModel.fromMap(maps[i]);
    }).firstOrNull;
  }

  Future<List<HadithModel>> getHadithListByContentId(int contentId) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM hadith where contentId = ?', [contentId]);

    return List.generate(maps.length, (i) {
      return HadithModel.fromMap(maps[i]);
    });
  }

  Future<List<HadithModel>> searchHadith({
    required String searchText,
    required SearchType searchType,
    required int limit,
    required int offset,
  }) async {
    if (searchText.isEmpty) return [];

    final Database db = await database;

    final whereFilters = _searchTitlesSearchType(
      searchText,
      "searchText",
      searchType: searchType,
      useFilters: true,
    );

    appPrint(whereFilters);

    final String qurey =
        '''SELECT * FROM hadith ${whereFilters.query} LIMIT ? OFFSET ?''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      qurey,
      [...whereFilters.args, limit, offset],
    );

    return List.generate(maps.length, (i) {
      return HadithModel.fromMap(maps[i]);
    });
  }

  ///*********************************** */
  ///MARK: Titles and Maqassed

  Future<List<TitleModel>> getAllMaqassed() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT 
    t1.id,
    t1.name,
    t1.searchText,
    t1.parentId,
    COUNT(t2.id) AS subTitlesCount
FROM 
    titles t1
LEFT JOIN 
    titles t2
ON 
    t1.id = t2.parentId
WHERE 
    t1.parentId IS NULL
GROUP BY 
    t1.id, t1.name, t1.searchText, t1.parentId;
''');

    return List.generate(maps.length, (i) {
      return TitleModel.fromMap(maps[i]);
    });
  }

  Future<List<TitleModel>> getSubTitlesByTitleId(int titleId) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT 
    t1.id,
    t1.name,
    t1.searchText,
    t1.parentId,
    COUNT(t2.id) AS subTitlesCount
FROM 
    titles t1
LEFT JOIN 
    titles t2
ON 
    t1.id = t2.parentId
WHERE 
    t1.parentId = ?
GROUP BY 
    t1.id, t1.name, t1.searchText, t1.parentId;
''', [titleId]);

    return List.generate(maps.length, (i) {
      return TitleModel.fromMap(maps[i]);
    });
  }

  Future<TitleModel?> getTitleById(int titleId) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
SELECT 
    t1.id,
    t1.name,
    t1.searchText,
    t1.parentId,
    COUNT(t2.id) AS subTitlesCount
FROM 
    titles t1
LEFT JOIN 
    titles t2
ON 
    t1.id = t2.parentId
WHERE 
    t1.id = ?
GROUP BY 
    t1.id, t1.name, t1.searchText, t1.parentId;
''',
      [titleId],
    );

    return List.generate(maps.length, (i) {
      return TitleModel.fromMap(maps[i]);
    }).firstOrNull;
  }

  Future<List<TitleModel>> getTitleChain(int titleId) async {
    final List<TitleModel> titles = [];

    final title = await getTitleById(titleId);
    if (title == null) return titles;
    titles.add(title);

    while (titles.last.parentId != -1) {
      final title = await getTitleById(titles.last.parentId);
      if (title == null) break;
      titles.add(title);
    }
    return titles.reversed.toList();
  }

  SqlQuery _searchTitlesSearchType(
    String searchText,
    String property, {
    required SearchType searchType,
    required bool useFilters,
  }) {
    final SqlQuery sqlQuery = SqlQuery();

    final List<String> splittedSearchWords = searchText.trim().split(' ');

    switch (searchType) {
      case SearchType.typical:
        sqlQuery.query = 'WHERE $property LIKE ?';
        sqlQuery.args.addAll(['%$searchText%']);

      case SearchType.allWords:
        final String allWordsQuery =
            splittedSearchWords.map((word) => '$property LIKE ?').join(' AND ');
        final List<String> params =
            splittedSearchWords.map((word) => '%$word%').toList();
        sqlQuery.query = 'WHERE ($allWordsQuery)';
        sqlQuery.args.addAll([...params]);

      case SearchType.anyWords:
        final String allWordsQuery =
            splittedSearchWords.map((word) => '$property LIKE ?').join(' OR ');
        final List<String> params =
            splittedSearchWords.map((word) => '%$word%').toList();
        sqlQuery.query = 'WHERE ($allWordsQuery)';
        sqlQuery.args.addAll([...params]);
    }

    return sqlQuery;
  }

  Future<List<TitleModel>> searchTitleByName({
    required String searchText,
    required SearchType searchType,
    required int limit,
    required int offset,
  }) async {
    if (searchText.isEmpty) return [];

    final Database db = await database;

    final whereFilters = _searchTitlesSearchType(
      searchText,
      "t1.searchText",
      searchType: searchType,
      useFilters: true,
    );

    final String qurey = '''
SELECT 
    t1.id,
    t1.name,
    t1.searchText,
    t1.parentId,
    COUNT(t2.id) AS subTitlesCount
FROM 
    titles t1
LEFT JOIN 
    titles t2
ON 
    t1.id = t2.parentId
${whereFilters.query}
GROUP BY 
    t1.id, t1.name, t1.searchText, t1.parentId
LIMIT ? OFFSET ?
''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      qurey,
      [...whereFilters.args, limit, offset],
    );

    return List.generate(maps.length, (i) {
      return TitleModel.fromMap(maps[i]);
    });
  }

  ///*********************************** */
  ///MARK: contents
  Future<int> getContentCount() async {
    final Database db = await database;

    // Execute the raw SQL query to count the rows
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) as count FROM contents');

    // Extract the count from the result
    if (result.isNotEmpty) {
      return result.first['count'] as int;
    }

    // Return 0 if no rows exist
    return 0;
  }

  Future<RangeValues> getContentTitleIdRange() async {
    final Database db =
        await database; // Assuming `database` is your db connection.

    // Query to get the min and max titleId.
    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT MIN(titleId) as minTitleId, MAX(titleId) as maxTitleId FROM contents
  ''');

    if (results.isNotEmpty) {
      final row = results.first;
      int minTitleId = row['minTitleId'];
      int maxTitleId = row['maxTitleId'];

      return RangeValues(minTitleId.toDouble(), maxTitleId.toDouble());
    }

    return RangeValues(0, 0); // Default if no results.
  }

  Future<ContentModel> getContentByTitleId(int titleId) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery('''SELECT * from contents where titleId = ?''', [titleId]);

    return List.generate(maps.length, (i) {
      return ContentModel.fromMap(maps[i]);
    }).first;
  }

  Future<ContentModel> getContentById(int contentId) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery('''SELECT * from contents where id = ?''', [contentId]);

    return List.generate(maps.length, (i) {
      return ContentModel.fromMap(maps[i]);
    }).first;
  }

  Future<List<ContentModel>> searchContent({
    required String searchText,
    required SearchType searchType,
    required int limit,
    required int offset,
  }) async {
    if (searchText.isEmpty) return [];

    final Database db = await database;

    final whereFilters = _searchTitlesSearchType(
      searchText,
      "searchText",
      searchType: searchType,
      useFilters: true,
    );

    final String qurey =
        '''SELECT * FROM contents ${whereFilters.query} LIMIT ? OFFSET ?''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      qurey,
      [...whereFilters.args, limit, offset],
    );

    return List.generate(maps.length, (i) {
      return ContentModel.fromMap(maps[i]);
    });
  }

  /// Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}
