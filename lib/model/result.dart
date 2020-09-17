import 'package:equatable/equatable.dart';

class Result extends Equatable {
  final List<SingleQuestionResult> questionResults;
  final Grade grade;
  final int percentCorrect;
  final int correctCt;

  Result(this.questionResults, this.grade, this.percentCorrect, this.correctCt);

  @override
  List<Object> get props => [questionResults, grade, percentCorrect, correctCt];
}

class SingleQuestionResult extends Equatable {
  final String question;
  final String correctAnswer;
  final String incorrectAnswer;
  final bool correct;

  SingleQuestionResult(this.question, this.correctAnswer, this.incorrectAnswer, this.correct);

  @override
  List<Object> get props => [question, correctAnswer, incorrectAnswer, correct];
}

enum Grade {
  EXCELLENT, GREAT, GOOD
}