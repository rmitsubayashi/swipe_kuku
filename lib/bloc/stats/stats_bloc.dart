import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/bloc/questions/question_generator.dart';
import 'package:swipe_kuku/bloc/questions/questions_bloc.dart';
import 'package:swipe_kuku/bloc/stats/selected_question/selected_question_bloc.dart';
import 'package:swipe_kuku/bloc/stats/stats_event.dart';
import 'package:swipe_kuku/bloc/stats/stats_state.dart';
import 'package:swipe_kuku/model/question_record.dart';
import 'package:swipe_kuku/model/stats.dart';
import 'package:swipe_kuku/repository/question_record_repository.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final QuestionRecordRepository questionRecordRepository;
  final QuestionsBloc questionsBloc;
  final SelectedQuestionBloc selectedQuestionBloc;

  StatsBloc({
    @required this.questionRecordRepository,
    @required this.questionsBloc,
    @required this.selectedQuestionBloc
  }) : super(StatsLoading()) {
    questionsBloc.questionsFinishedStream.listen((event) {
      if (event) {
        add(LoadStats());
      }
    });
  }

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is LoadStats) {
      yield* _mapLoadStatsToState();
    } else if (event is ResetStats) {
      yield* _mapResetStatsToState();
    }
  }

  Stream<StatsState> _mapLoadStatsToState() async* {
    final records = await questionRecordRepository.getAll();
    if (records.isEmpty) {
      yield StatsEmpty();
      return;
    }
    final heatMap = _calculateHeat(records);
    final correctPercentage = _calculateCorrectPercentage(records);
    final grade = _generateGrade(records);

    final stats = Stats(
        questionHeatMap: heatMap,
        correctPercentage: correctPercentage,
        correctPercentageGrade: grade);

    yield StatsLoaded(stats: stats);
  }

  List<List<Heat>> _calculateHeat(List<QuestionRecord> records) {
    final correctList = List<List<List<bool>>>(9);
    for (var i = 0; i < 9; i++) {
      correctList[i] = List<List<bool>>(9);
      for (var j = 0; j < 9; j++) {
        correctList[i][j] = List<bool>();
      }
    }
    for (final record in records) {
      final multiplePair = QuestionGenerator.fromQuestion(record.question);
      //shouldn't happen
      if (multiplePair == null) continue;
      correctList[multiplePair.first-1][multiplePair.second-1].add(record.correct);
    }

    final heatMap = List<List<Heat>>(9);
    for (var i = 0; i < 9; i++) {
      heatMap[i] = List<Heat>(9);
    }
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        final correctData = correctList[i][j];
        Heat heat;
        if (correctData.isEmpty) {
          heat = Heat.NONE;
        } else {
          final total = correctData.length;
          final correctCt =
              correctData.where((element) => element == true).length;
          final correctPercentage = correctCt / total;
          if (correctPercentage > 0.95) {
            heat = Heat.COLD;
          } else if (correctPercentage > 0.9) {
            heat = Heat.COOL;
          } else if (correctPercentage > 0.8) {
            heat = Heat.WARM;
          } else {
            heat = Heat.HOT;
          }
          heatMap[i][j] = heat;
        }
      }
    }
    return heatMap;
  }

  int _calculateCorrectPercentage(List<QuestionRecord> records) {
    final total = records.length;
    final correctCt = records.where((element) => element.correct).length;
    return (100 * correctCt) ~/ total;
  }

  CorrectPercentageGrade _generateGrade(
      List<QuestionRecord> records) {
    final correctPercentage = _calculateCorrectPercentage(records);
    if (correctPercentage >= 95) {
      return CorrectPercentageGrade.EXCELLENT;
    } else if (correctPercentage >= 90) {
      return CorrectPercentageGrade.GREAT;
    } else {
      return CorrectPercentageGrade.GOOD;
    }
  }

  Stream<StatsState> _mapResetStatsToState() async* {
    await questionRecordRepository.deleteAll();
    yield StatsEmpty();
  }
}
