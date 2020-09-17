import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:swipe_kuku/bloc/result/result_bloc.dart';
import 'package:swipe_kuku/bloc/result/result_state.dart';
import 'package:swipe_kuku/model/result.dart';
import 'package:swipe_kuku/translation/translation_map.dart';
import 'package:swipe_kuku/ui/common_screens.dart';
import 'package:swipe_kuku/ui/routes.dart';
import 'package:swipe_kuku/util/correct_colors.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultBloc, ResultState>(
      builder: (context, state) {
        if (state is CalculatingResults) {
          return CommonScreens.loading(
              TranslationMap.of(context).resultsTitleText, context);
        } else if (state is ResultsCalculated) {
          return Scaffold(
              appBar: AppBar(
                title: Text(TranslationMap.of(context).resultsTitleText),
              ),
              body: Column(children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: state.result.questionResults.length + 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Container(
                              child: Text(
                                _mapGradeToText(state.result.grade, context),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 36),
                              ),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 24, bottom: 24),
                            );
                          }
                          if (index == 1) {
                            return ListTile(
                                title: CircularPercentIndicator(
                              radius: MediaQuery.of(context).size.width * 0.4,
                              lineWidth: 10.0,
                              percent: state.result.percentCorrect / 100,
                              progressColor:
                                  _mapGradeToColor(state.result.grade),
                              center: Text(
                                "${state.result.correctCt}/${state.result.questionResults.length}",
                                style: TextStyle(
                                    color: _mapGradeToColor(state.result.grade),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ));
                          }
                          final item = state.result.questionResults[index - 2];
                          return ListTile(
                            title: Text(item.question),
                            subtitle: Text(item.correct
                                ? TranslationMap.of(context).resultsCorrect
                                : TranslationMap.of(context).resultsIncorrect),
                          );
                        })),
                Container(
                  child: RaisedButton(
                    child: Text(
                      TranslationMap.of(context).resultsToHome,
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      // pop all screens before this
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.home, (route) => false);
                    },
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                )
              ]));
        } else {
          return CommonScreens.error(
              TranslationMap.of(context).resultsTitleText, context);
        }
      },
    );
  }

  String _mapGradeToText(Grade grade, BuildContext context) {
    if (grade == Grade.EXCELLENT) {
      return TranslationMap.of(context).resultsExcellent;
    } else if (grade == Grade.GREAT) {
      return TranslationMap.of(context).resultsGreat;
    } else {
      return TranslationMap.of(context).resultsGood;
    }
  }

  Color _mapGradeToColor(Grade grade) {
    if (grade == Grade.EXCELLENT) {
      return CorrectColors.green;
    } else if (grade == Grade.GREAT) {
      return CorrectColors.yellow;
    } else {
      return CorrectColors.orange;
    }
  }
}
