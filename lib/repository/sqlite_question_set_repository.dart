import 'package:sqflite/sqflite.dart';
import 'package:swipe_kuku/model/question_set.dart';
import 'package:swipe_kuku/repository/question_set_repository.dart';

class SqliteQuestionSetRepository implements QuestionSetRepository {
  Future<Database> _db;

  SqliteQuestionSetRepository(this._db);

  @override
  Future<QuestionSet> insert(QuestionSet questionSet) async {
    final db = await _db;
    final id = await db.insert(tableName, {createdAt: questionSet.createdAt.millisecondsSinceEpoch});
    final newQuestionSet = QuestionSet(questionSet.createdAt);
    newQuestionSet.id = id;
    return newQuestionSet;
  }

  static final String tableName = "questionSet";
  static final String id = "id";
  static final String createdAt = "createdAt";

  static final String tableQuery =
    "CREATE TABLE $tableName("
      "$id INTEGER PRIMARY KEY, "
      "$createdAt INTEGER"
    ")"
  ;

}