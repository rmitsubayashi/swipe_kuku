import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:swipe_kuku/bloc/stats/selected_question/selected_question_bloc.dart';
import 'package:swipe_kuku/bloc/stats/selected_question/selected_question_event.dart';
import 'package:swipe_kuku/bloc/stats/selected_question/selected_question_state.dart';
import 'package:swipe_kuku/bloc/stats/stats_bloc.dart';
import 'package:swipe_kuku/bloc/stats/stats_event.dart';
import 'package:swipe_kuku/bloc/stats/stats_state.dart';
import 'package:swipe_kuku/model/stats.dart';
import 'package:swipe_kuku/translation/translation_map.dart';
import 'package:swipe_kuku/ui/common_screens.dart';
import 'package:swipe_kuku/util/correct_colors.dart';
import 'package:swipe_kuku/util/pair.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statsBloc = BlocProvider.of<StatsBloc>(context);
    return BlocBuilder<StatsBloc, StatsState>(builder: (context, state) {
      if (state is StatsLoading) {
        return CommonScreens.loading(
            TranslationMap.of(context).statsTitleText, context);
      } else if (state is StatsLoaded) {
        return Scaffold(
            appBar: AppBar(
              title: Text(TranslationMap.of(context).statsTitleText),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    semanticLabel: TranslationMap.of(context).removeStatsText,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(TranslationMap.of(context).removeStatsConfirmText),
                            actions: [
                              FlatButton(
                                child: Text(TranslationMap.of(context).removeStatsNoText),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text(TranslationMap.of(context).removeStatsYesText),
                                onPressed: () {
                                  statsBloc.add(ResetStats());
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  },
                )
              ],
            ),
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Text(
                  TranslationMap.of(context).statsHeatMap,
                  style: TextStyle(fontSize: 24),
                ),
                margin: EdgeInsets.only(top: 16, left: 16),
              ),
              Container(
                height: MediaQuery.of(context).size.width * 10 / 11,
                child: GridView.count(
                  crossAxisCount: 11,
                  children: List.generate(110, (index) {
                    final tens = index ~/ 10;
                    final ones = index % 10;
                    if (index == 0) {
                      // the top left corner
                      return Container();
                    } else if (index % 11 == 0) {
                      // left column
                      final intVal = index ~/ 11;
                      return Center(child: Text(intVal.toString()));
                    } else if (tens - ones == 1) {
                      // right column
                      return Container();
                    } else if (index < 11) {
                      // top row
                      return Center(child: Text(index.toString()));
                    } else {
                      final first = index % 11;
                      final second = index ~/ 11;
                      final heat =
                          state.stats.questionHeatMap[first - 1][second - 1];
                      return Container(
                        color: _mapHeatMapToColor(heat),
                        child: FlatButton(
                          child: Container(),
                          onPressed: () => statsBloc.selectedQuestionBloc.add(
                              SelectQuestion(
                                  selectedQuestion: Pair(first, second))),
                        ),
                      );
                    }
                  }),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          CircularPercentIndicator(
                              radius: 100,
                              lineWidth: 10,
                              percent: state.stats.correctPercentage / 100,
                              progressColor: _mapGradeToColor(
                                  state.stats.correctPercentageGrade),
                              center: Text(
                                "${state.stats.correctPercentage}%",
                                style: TextStyle(
                                    color: _mapGradeToColor(
                                        state.stats.correctPercentageGrade)),
                              )),
                          Text(
                              TranslationMap.of(context)
                                  .statsCorrectPercentageText,
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      BlocBuilder<SelectedQuestionBloc, SelectedQuestionState>(
                        builder: (context, selectedQuestionState) {
                          if (selectedQuestionState is Selected) {
                            return Column(children: [
                              CircularPercentIndicator(
                                  radius: 100,
                                  lineWidth: 10,
                                  percent: selectedQuestionState
                                          .questionStats.correctPercentage /
                                      100,
                                  progressColor: _mapHeatMapToColor(state.stats
                                      .questionHeatMap[selectedQuestionState
                                          .questionStats.question.first -
                                      1][selectedQuestionState
                                          .questionStats.question.second -
                                      1]),
                                  center: Text(
                                    "${selectedQuestionState.questionStats.correctPercentage}%",
                                    style: TextStyle(
                                        color: _mapHeatMapToColor(
                                            state
                                                        .stats.questionHeatMap[
                                                    selectedQuestionState
                                                            .questionStats
                                                            .question
                                                            .first -
                                                        1][
                                                selectedQuestionState
                                                        .questionStats
                                                        .question
                                                        .second -
                                                    1])),
                                  )),
                              Text(
                                "${selectedQuestionState.questionStats.question.first} x ${selectedQuestionState.questionStats.question.second}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ]);
                          } else {
                            return Text(TranslationMap.of(context).statsClickSquare);
                          }
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  )),
            ]));
      } else if (state is StatsEmpty) {
        return Scaffold(
            appBar: AppBar(
              title: Text(TranslationMap.of(context).statsTitleText),
            ),
            body:
                Center(child: Text(TranslationMap.of(context).emptyStatsText)));
      } else {
        return CommonScreens.error(
            TranslationMap.of(context).statsTitleText, context);
      }
    });
  }

  Color _mapGradeToColor(CorrectPercentageGrade grade) {
    if (grade == CorrectPercentageGrade.EXCELLENT) {
      return CorrectColors.green;
    } else if (grade == CorrectPercentageGrade.GREAT) {
      return CorrectColors.yellow;
    } else {
      return CorrectColors.orange;
    }
  }

  Color _mapHeatMapToColor(Heat heat) {
    if (heat == Heat.HOT) {
      return CorrectColors.red;
    } else if (heat == Heat.COLD) {
      return CorrectColors.green;
    } else if (heat == Heat.COOL) {
      return CorrectColors.yellow;
    } else if (heat == Heat.WARM) {
      return CorrectColors.orange; // orange
    } else {
      return Color.fromARGB(255, 224, 224, 224); // gray 300
    }
  }
}
