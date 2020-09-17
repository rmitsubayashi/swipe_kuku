import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/util/pair.dart';

abstract class SelectedQuestionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectQuestion extends SelectedQuestionEvent {
  final Pair<int, int> selectedQuestion;
  SelectQuestion({@required this.selectedQuestion});

  @override
  List<Object> get props => [selectedQuestion];
}

class DeselectQuestion extends SelectedQuestionEvent {
  @override
  List<Object> get props => [];
}