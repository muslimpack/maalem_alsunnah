import 'dart:async';

import 'package:maalem_alsunnah/src/core/utils/db_helper.dart';
import 'package:maalem_alsunnah/src/features/home/data/models/hadith_ruling_enum.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/search_header.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/search_result_info.dart';
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

  Future<List<Hadith>> getAll() async {
    final Database db = await database;

    ///TODO |  ORDER BY `order` ASC
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM hadith');

    return List.generate(maps.length, (i) {
      return Hadith.fromMap(maps[i]);
    });
  }

  Future<Hadith?> getHadithById(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FRMO hadith where id = ?', [id]);

    return List.generate(maps.length, (i) {
      return Hadith.fromMap(maps[i]);
    }).firstOrNull;
  }

  Future<List<Hadith>> searchByHadithText(String hadithText) async {
    if (hadithText.isEmpty) return [];

    final Database db = await database;

    ///TODO |  ORDER BY `order` ASC
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM hadith WHERE hadith LIKE ?',
      ['%$hadithText%'],
    );

    return List.generate(maps.length, (i) {
      return Hadith.fromMap(maps[i]);
    });
  }

  Future<SearchResultInfo> searchByHadithTextWithFiltersInfo(
    String searchText, {
    required List<HadithRulingEnum> ruling,
    required SearchType searchType,
  }) async {
    if (searchText.isEmpty || ruling.isEmpty) return SearchResultInfo.empty();

    final total = await _searchByHadithTextWithFiltersInfo(
      searchText,
      ruling: ruling,
      searchType: searchType,
      useFilters: false,
    );
    final filtered = await _searchByHadithTextWithFiltersInfo(
      searchText,
      ruling: ruling,
      searchType: searchType,
      useFilters: true,
    );

    return SearchResultInfo(total: total, filtered: filtered);
  }

  SqlQuery _searchByHadithTextWithFiltersSqlQuery(
    String searchText, {
    required SearchType searchType,
    required List<HadithRulingEnum> ruling,
    required bool useFilters,
    required bool onlyHeader,
  }) {
    final SqlQuery sqlQuery = SqlQuery();

    final rulingString = ruling
        .map((e) => e.title)
        .map((word) => "ruling LIKE '%$word%'")
        .join(' OR ');
    final rulingQuery = !useFilters ? "" : ' AND ($rulingString) ';

    final List<String> splittedSearchWords = searchText.trim().split(' ');

    final dataForm = onlyHeader ? SearchHeader.query : "*";

    switch (searchType) {
      case SearchType.typical:
        sqlQuery.query =
            'SELECT $dataForm FROM hadith WHERE hadith LIKE ? $rulingQuery';
        sqlQuery.args.addAll(['%$searchText%']);

      case SearchType.allWords:
        final String allWordsQuery =
            splittedSearchWords.map((word) => 'hadith LIKE ?').join(' AND ');
        final List<String> params =
            splittedSearchWords.map((word) => '%$word%').toList();
        sqlQuery.query =
            'SELECT $dataForm FROM hadith WHERE ($allWordsQuery) $rulingQuery';
        sqlQuery.args.addAll([...params]);

      case SearchType.anyWords:
        final String allWordsQuery =
            splittedSearchWords.map((word) => 'hadith LIKE ?').join(' OR ');
        final List<String> params =
            splittedSearchWords.map((word) => '%$word%').toList();
        sqlQuery.query =
            'SELECT $dataForm FROM hadith WHERE ($allWordsQuery) $rulingQuery';
        sqlQuery.args.addAll([...params]);
    }

    return sqlQuery;
  }

  Future<SearchHeader> _searchByHadithTextWithFiltersInfo(
    String searchText, {
    required SearchType searchType,
    required List<HadithRulingEnum> ruling,
    required bool useFilters,
  }) async {
    if (searchText.isEmpty || (useFilters && ruling.isEmpty)) {
      return SearchHeader.empty();
    }

    final Database db = await database;

    final SqlQuery sqlQuery = _searchByHadithTextWithFiltersSqlQuery(
      searchText,
      searchType: searchType,
      ruling: ruling,
      useFilters: useFilters,
      onlyHeader: true,
    );

    final List<Map<String, dynamic>> maps =
        await db.rawQuery(sqlQuery.query, sqlQuery.args);

    return SearchHeader.fromMap(maps.first);
  }

  Future<List<Hadith>> searchByHadithTextWithFilters(
    String searchText, {
    required List<HadithRulingEnum> ruling,
    required SearchType searchType,
    required int limit, // Number of items per page
    required int offset, // Offset to start fetching items from
  }) async {
    if (searchText.isEmpty || ruling.isEmpty) return [];

    final Database db = await database;

    final SqlQuery sqlQuery = _searchByHadithTextWithFiltersSqlQuery(
      searchText,
      searchType: searchType,
      ruling: ruling,
      useFilters: true,
      onlyHeader: false,
    );

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '${sqlQuery.query} LIMIT ? OFFSET ?',
      [...sqlQuery.args, limit, offset],
    );

    return List.generate(maps.length, (i) {
      return Hadith.fromMap(maps[i]);
    });
  }

  Future<List<Hadith>> searchByRawy(String rawy) async {
    final Database db = await database;

    ///TODO |  ORDER BY `order` ASC
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM hadith WHERE hadith LIKE ?',
      ['%$rawy%'],
    );

    return List.generate(maps.length, (i) {
      return Hadith.fromMap(maps[i]);
    });
  }

  Future<Hadith?> randomHadith(HadithRulingEnum ruling) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM hadith WHERE ruling like ? ORDER BY RANDOM() LIMIT 1',
      ['%${ruling.title}%'],
    );

    if (maps.isNotEmpty) {
      return Hadith.fromMap(maps.first);
    }

    return null;
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

  Future<List<TitleModel>> getTitleById(int id) async {
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
''', [id]);

    return List.generate(maps.length, (i) {
      return TitleModel.fromMap(maps[i]);
    });
  }

  ///*********************************** */
  ///MARK: contents
  Future<ContentModel> getContentByTitleId(int titleId) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery('''SELECT * from contents where titleId = ?''', [titleId]);

    return List.generate(maps.length, (i) {
      return ContentModel.fromMap(maps[i]);
    }).first;
  }

  /// Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}
