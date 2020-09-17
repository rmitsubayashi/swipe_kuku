import 'package:swipe_kuku/model/question_set.dart';

abstract class QuestionSetRepository {
  Future<QuestionSet> insert(QuestionSet questionSet);
}