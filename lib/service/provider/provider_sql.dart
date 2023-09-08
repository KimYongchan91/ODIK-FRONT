import 'package:odik/const/model/model_history_search_keyword.dart';
import 'package:odik/const/value/key.dart';
import 'package:sqflite/sqflite.dart';

import '../../my_app.dart';

const String nameDatabase = 'db_odik_common';
const String nameTableHistorySearchKeyword = 'history_search_keyword';

class ProviderSQL {
  Database? database;

  ProviderSQL() {
    openDatabase(
      nameDatabase,
      version: 1,
      onCreate: _onCreate,
    ).then((value) => database = value);
  }

  _onCreate(Database db, int version) async {
    if (version <= 1) {
      await db.execute("CREATE TABLE $nameTableHistorySearchKeyword ("
          "$keyIdx INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$keyKeyword VARCHAR(20) NOT NULL,"
          "$keyDateCreate INTEGER NOT NULL"
          ")");
    }
  }

  addKeyword(String keyword) async {
    //이미 존재한다면 삭제
    await deleteKeyword(keyword);

    await database?.rawInsert(
        'INSERT INTO $nameTableHistorySearchKeyword '
        '($keyKeyword, $keyDateCreate) '
        'VALUES '
        '(?,?)',
        [keyword, DateTime.now().millisecondsSinceEpoch]);
  }

  deleteKeyword(String keyword) async {
    await database?.rawDelete(
        'DELETE FROM $nameTableHistorySearchKeyword '
        'WHERE '
        '$keyKeyword = ?',
        [keyword]);
  }

  Future<List<ModelHistorySearchKeyword>> getAllHistory() async {
    List<ModelHistorySearchKeyword> result = [];
    if (database != null) {
      try {
        List<Map<String, Object?>>? raw = await database
            ?.rawQuery('SELECT * FROM $nameTableHistorySearchKeyword ORDER BY $keyDateCreate DESC');

        raw?.forEach((element) {
          ModelHistorySearchKeyword modelHistorySearchKeyword = ModelHistorySearchKeyword(
            idx: (element[keyIdx] ?? 0) as int,
            keyword: (element[keyKeyword] ?? '') as String,
            dateCreate: DateTime.fromMillisecondsSinceEpoch((element[keyDateCreate] ?? 0) as int),
          );

          result.add(modelHistorySearchKeyword);
        });
      } catch (e) {
        MyApp.logger.wtf("에러 발생 : ${e.toString()}");
      }
    }
    return result;
  }
}
