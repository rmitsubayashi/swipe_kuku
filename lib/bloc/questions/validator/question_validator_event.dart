import 'package:equatable/equatable.dart';
import 'package:swipe_kuku/model/question.dart';

abstract class QuestionValidatorEvent extends Equatable {
  const QuestionValidatorEvent();
}

class CheckAnswer extends QuestionValidatorEvent {
  final Question question;
  final String answer;

  const CheckAnswer(this.question, this.answer);

  @override
  List<Object> get props => [question, answer];

  @override
  String toString() => "Check Answer { question: $question answer: $answer }";
}

class ResetAnswer extends QuestionValidatorEvent {
  @override
  List<Object> get props => [];
}