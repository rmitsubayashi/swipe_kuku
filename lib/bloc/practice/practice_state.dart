import 'package:equatable/equatable.dart';
import 'package:swipe_kuku/model/question.dart';

abstract class PracticeState {
  const PracticeState();
}

class LoadingPracticeQuestions extends PracticeState {
  @override
  List<Object> get props => [];
}

class PracticeQuestionsLoaded extends PracticeState {
  final List<Question> questions;

  const PracticeQuestionsLoaded(this.questions);

  @override
  List<Object> get props => [questions];
}