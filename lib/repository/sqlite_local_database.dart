import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swipe_kuku/repository/sqlite_question_record_repository.dart';
import 'package:swipe_kuku/repository/sqlite_question_set_repository.dart';

class LocalDatabase {
  static Future<Database> _db;

  static Future<Database> getInstance() async {
    if (_db == null) {
      _db = openDatabase(
        join(await getDatabasesPath(), "kuku.db"),
        onCreate: (db, version) {
          db.execute(SqliteQuestionRecordRepository.tableQuery);
          db.execute(SqliteQuestionSetRepository.tableQuery);
        },
        version: 1,
      );
    }
    return _db;
  }
}