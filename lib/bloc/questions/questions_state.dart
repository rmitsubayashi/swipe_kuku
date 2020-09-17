import 'package:equatable/equatable.dart';
import 'package:swipe_kuku/model/question.dart';

abstract class QuestionsState extends Equatable {
  const QuestionsState();
}

class LoadingQuestions extends QuestionsState {
  @override
  List<Object> get props => [];
}

class QuestionsLoaded extends QuestionsState {
  final List<Question> questions;
  final int questionSetID;

  const QuestionsLoaded(this.questions, this.questionSetID);

  @override
  List<Object> get props => [questions];
}

class QuestionsFinished extends QuestionsState {
  final int questionSetID;

  const QuestionsFinished(this.questionSetID);

  @override
  List<Object> get props => [questionSetID];
}