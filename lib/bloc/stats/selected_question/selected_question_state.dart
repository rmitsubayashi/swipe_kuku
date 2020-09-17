import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/model/question_stats.dart';

abstract class SelectedQuestionState extends Equatable {
  const SelectedQuestionState();
  @override
  List<Object> get props => [];
}

class NotSelected extends SelectedQuestionState {}

class Selected extends SelectedQuestionState {
  final QuestionStats questionStats;
  Selected({@required this.questionStats});

  @override
  List<Object> get props => [questionStats];
}