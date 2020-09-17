import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/bloc/questions/question_generator.dart';
import 'package:swipe_kuku/bloc/stats/selected_question/selected_question_event.dart';
import 'package:swipe_kuku/bloc/stats/selected_question/selected_question_state.dart';
import 'package:swipe_kuku/model/question_stats.dart';
import 'package:swipe_kuku/repository/question_record_repository.dart';

class SelectedQuestionBloc extends Bloc<SelectedQuestionEvent, SelectedQuestionState> {
  final QuestionRecordRepository questionRecordRepository;

  SelectedQuestionBloc({
    @required this.questionRecordRepository
  }): super(NotSelected());

  @override
  Stream<SelectedQuestionState> mapEventToState(SelectedQuestionEvent event) async* {
    if (event is SelectQuestion) {
      yield* _mapSelectQuestionToState(event);
    } else if (event is DeselectQuestion) {
      yield* _mapDeselectQuestionToState();
    }
  }

  Stream<SelectedQuestionState> _mapSelectQuestionToState(SelectQuestion event) async* {
    String question = QuestionGenerator.formatQuestion(
        event.selectedQuestion.first, event.selectedQuestion.second
    );
    final questionRecords = await questionRecordRepository.getByQuestion(question);
    final total = questionRecords.length;
    final correctCt = questionRecords.where((element) => element.correct).length;
    int correctPercentage;
    if (total == 0) {
      correctPercentage = 0;
    }  else {
      correctPercentage = (correctCt * 100) ~/ total;
    }
    final stats = QuestionStats(event.selectedQuestion, correctPercentage, total);
    yield Selected(questionStats: stats);
  }

  Stream<SelectedQuestionState> _mapDeselectQuestionToState() async* {
    yield NotSelected();
  }

}