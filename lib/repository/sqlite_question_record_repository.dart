import 'package:sqflite/sqflite.dart';
import 'package:swipe_kuku/model/question_record.dart';
import 'package:swipe_kuku/repository/question_record_repository.dart';
import 'package:swipe_kuku/repository/sqlite_question_set_repository.dart';

class SqliteQuestionRecordRepository implements QuestionRecordRepository {
  Future<Database> _db;

  SqliteQuestionRecordRepository(this._db);

  @override
  Future<List<QuestionRecord>> getAll() async {
    final db = await _db;
    final maps = await db.query(tableName, distinct: true, columns: null);
    final list = List<QuestionRecord>();
    for (var map in maps) {
      list.add(QuestionRecord.fromMap(map));
    }
    return list;
  }

  @override
  Future<List<QuestionRecord>> getByQuestion(String question) async {
    final db = await _db;
    final maps = await db.query(tableName, distinct: true, columns: null, where: "${SqliteQuestionRecordRepository.question} = '$question'");
    final list = List<QuestionRecord>();
    for (var map in maps) {
      list.add(QuestionRecord.fromMap(map));
    }
    return list;
  }

  @override
  Future<List<QuestionRecord>> getByQuestionSetID(int questionSetID) async {
    final db = await _db;
    final maps = await db.query(tableName, distinct: true, columns: null, where: "${SqliteQuestionRecordRepository.questionSetID} = $questionSetID");
    final list = List<QuestionRecord>();
    for (var map in maps) {
      list.add(QuestionRecord.fromMap(map));
    }
    return list;
  }

  @override
  Future<QuestionRecord> insert(QuestionRecord questionRecord) async {
    final db = await _db;
    final id = await db.insert(tableName, {
      questionSetID: questionRecord.questionSetID,
      question: questionRecord.question,
      answer: questionRecord.answer,
      choices: _listToString(questionRecord.choices),
      userAnswer: questionRecord.userAnswer,
      correct: questionRecord.correct ? 1 : 0
    });
    return QuestionRecord.withId(questionRecord, id);
  }

  String _listToString(List<String> list) {
    return list.join('|');
  }

  @override
  Future<bool> deleteAll() async {
    final db = await _db;
    await db.delete(tableName);
    return true;
  }


  static final String tableName = "questionRecord";
  static final String id = "id";
  static final String questionSetID = "questionSetID";
  static final String question = "question";
  static final String answer = "answer";
  static final String choices = "choices";
  static final String userAnswer = "userAnswer";
  static final String correct = "correct";

  static final String tableQuery =
    "CREATE TABLE $tableName("
      "$id INTEGER PRIMARY KEY, "
      "$questionSetID INTEGER, "
      "$question TEXT, "
      "$answer TEXT, "
      "$choices TEXT, "
      "$userAnswer TEXT, "
      "$correct INTEGER, "
      "FOREIGN KEY ($questionSetID) REFERENCES ${SqliteQuestionSetRepository.tableName}(${SqliteQuestionSetRepository.id})"
    ")"
  ;
}