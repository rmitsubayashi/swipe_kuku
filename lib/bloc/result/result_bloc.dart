import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/bloc/questions/questions_bloc.dart';
import 'package:swipe_kuku/bloc/questions/questions_state.dart';
import 'package:swipe_kuku/bloc/result/result_event.dart';
import 'package:swipe_kuku/bloc/result/result_state.dart';
import 'package:swipe_kuku/model/result.dart';
import 'package:swipe_kuku/repository/question_record_repository.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final QuestionRecordRepository questionRecordRepository;
  final QuestionsBloc questionsBloc;

  ResultBloc(
      {
        @required this.questionsBloc,
        @required this.questionRecordRepository
      }
  ): super(CalculatingResults()) {
    questionsBloc.questionsFinishedStream.listen((done) {
      if (done){
        add(CalculateResults());
      }
    });
  }

  @override
  Stream<ResultState> mapEventToState(ResultEvent event) async* {
    if (event is CalculateResults) {
      yield* _mapCalculateResultsToState(event);
    }
  }

  Stream<ResultState> _mapCalculateResultsToState(CalculateResults event) async* {
    if (!(questionsBloc.state is QuestionsLoaded)) {
      // technically should not happen
      return;
    }
    final questionSetID = (questionsBloc.state as QuestionsLoaded).questionSetID;
    final records = await questionRecordRepository.getByQuestionSetID(questionSetID);
    final singleQuestionResults = List<SingleQuestionResult>();
    for (final record in records) {
      final incorrectAnswer = record.choices[0] == record.answer ?
          record.choices[1] : record.choices[0];
      singleQuestionResults.add(
        SingleQuestionResult(record.question, record.answer, incorrectAnswer, record.correct)
      );
    }
    final correctCt = singleQuestionResults.where((element) => element.correct).length;
    final correctPercentage = (100 * correctCt) ~/ singleQuestionResults.length;
    var grade;
    if (correctPercentage == 100) {
      grade = Grade.EXCELLENT;
    } else if (correctPercentage > 90) {
      // averaged 90% accuracy for multiplication problems according to study
      grade = Grade.GREAT;
    } else {
      grade = Grade.GOOD;
    }
    yield ResultsCalculated(Result(singleQuestionResults, grade, correctPercentage, correctCt));
  }
}