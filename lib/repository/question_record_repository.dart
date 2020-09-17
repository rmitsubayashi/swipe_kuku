import 'package:swipe_kuku/model/question_record.dart';
import 'package:swipe_kuku/model/question_set.dart';

abstract class QuestionRecordRepository {
  Future<QuestionRecord> insert(QuestionRecord questionRecord);
  Future<List<QuestionRecord>> getByQuestionSetID(int questionSetID);
  Future<List<QuestionRecord>> getAll();
  Future<List<QuestionRecord>> getByQuestion(String question);
  Future<bool> deleteAll();
}