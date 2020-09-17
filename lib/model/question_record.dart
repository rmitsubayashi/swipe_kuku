import 'package:meta/meta.dart';
import 'package:swipe_kuku/model/question.dart';
import 'package:swipe_kuku/model/question_set.dart';
import 'package:swipe_kuku/repository/sqlite_question_record_repository.dart';

@immutable
class QuestionRecord {
  final int id;
  final int questionSetID;
  final String question;
  final String answer;
  final List<String> choices;
  final String userAnswer;
  final bool correct;

  QuestionRecord(QuestionSet questionSet, Question question, this.userAnswer, this.correct, [this.id = -1]):
      this.questionSetID = questionSet.id,
      this.question = question.question,
      this.answer = question.answer,
      this.choices = question.choices;

  QuestionRecord.withId(QuestionRecord original, int newID):
      this.id = newID,
      this.questionSetID = original.questionSetID,
      this.question = original.question,
      this.answer = original.answer,
      this.choices = original.choices,
      this.userAnswer = original.userAnswer,
      this.correct = original.correct;

  QuestionRecord.fromMap(Map<String, dynamic> map):
      this.id = map[SqliteQuestionRecordRepository.id],
      this.questionSetID = map[SqliteQuestionRecordRepository.questionSetID],
      this.question = map[SqliteQuestionRecordRepository.question],
      this.answer = map[SqliteQuestionRecordRepository.answer],
      this.choices = map[SqliteQuestionRecordRepository.choices].split('|'),
      this.userAnswer = map[SqliteQuestionRecordRepository.userAnswer],
      this.correct = map[SqliteQuestionRecordRepository.correct] == 1;
}