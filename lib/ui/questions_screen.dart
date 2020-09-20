import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:swipe_kuku/bloc/questions/questions_bloc.dart';
import 'package:swipe_kuku/bloc/questions/questions_event.dart';
import 'package:swipe_kuku/bloc/questions/questions_state.dart';
import 'package:swipe_kuku/bloc/questions/timer/timer_bloc.dart';
import 'package:swipe_kuku/bloc/questions/timer/timer_state.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_bloc.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_event.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_state.dart';
import 'package:swipe_kuku/translation/translation_map.dart';
import 'package:swipe_kuku/ui/common_screens.dart';
import 'package:swipe_kuku/ui/routes.dart';
import 'package:swipe_kuku/util/correct_colors.dart';

class QuestionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questionsBloc = BlocProvider.of<QuestionsBloc>(context);
    final cardController = CardController();
    return BlocBuilder<QuestionsBloc, QuestionsState>(
        builder: (context, state) {
      if (state is QuestionsLoaded) {
        return Scaffold(
            appBar: AppBar(
              title: Text(TranslationMap.of(context).questionsTitleText),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    questionsBloc.add(FinishQuestions());
                    Navigator.of(context).pop();
                  }),
            ),
            body: Column(mainAxisSize: MainAxisSize.max, children: [
              BlocBuilder<TimerBloc, TimerState>(
                builder: (context, timerState) {
                  if (timerState is TimerRunning) {
                    return LinearProgressIndicator(
                      value: timerState.percentLeft,
                      minHeight: 20,
                    );
                  } else {
                    // timer ready or finished
                    if (timerState is TimerFinished) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        // can't act on the ui while building, so swipe after build is complete
                        cardController.triggerUp();
                      });
                    }
                    return LinearProgressIndicator(
                      value: 0,
                      minHeight: 20,
                    );
                  }
                },
              ),
              Stack(alignment: Alignment.center, children: [
                Container(
                  height: MediaQuery.of(context).size.width + 100,
                  child: TinderSwapCard(
                    cardController: cardController,
                    cardBuilder: (context, index) {
                      return Card(
                          child: index == state.questions.length
                              ? FlatButton(
                                  child: Text(
                                    TranslationMap.of(context).questionsFinish,
                                    style: TextStyle(
                                        fontSize: 48,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  ),
                                  onPressed: () {
                                    questionsBloc.add(FinishQuestions());
                                    Navigator.of(context)
                                        .pushReplacementNamed(Routes.results);
                                  },
                                )
                              : Column(
                                  children: [
                                    Text(
                                      state.questions[index].question,
                                      style: TextStyle(
                                          fontSize: 56,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                    Container(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              state.questions[index].choices[0],
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            Text(
                                              state.questions[index].choices[1],
                                              style: TextStyle(fontSize: 24),
                                            )
                                          ]),
                                      margin: EdgeInsets.only(top: 24),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ));
                    },
                    stackNum: 3,
                    totalNum: state.questions.length + 1,
                    // final card goes to result screen
                    animDuration: 300,
                    swipeUp: true,
                    swipeDown: false,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.width * 0.9,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    minHeight: MediaQuery.of(context).size.width * 0.8,
                    swipeCompleteCallback:
                        (CardSwipeOrientation orientation, int index) {
                      if (index == state.questions.length) {
                        questionsBloc.add(FinishQuestions());
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.results);
                        return;
                      }
                      String choice = "";
                      if (orientation == CardSwipeOrientation.LEFT) {
                        choice = state.questions[index].choices[0];
                      } else if (orientation == CardSwipeOrientation.RIGHT) {
                        choice = state.questions[index].choices[1];
                      } else if (orientation == CardSwipeOrientation.UP) {
                        // user can swipe up if he does not know the answer
                        choice = state.questions[index].wrongChoice();
                      } else {
                        // down
                        return;
                      }
                      questionsBloc.questionValidatorBloc
                          .add(CheckAnswer(state.questions[index], choice));
                    },
                  ),
                ),
                BlocBuilder<QuestionValidatorBloc, QuestionValidatorState>(
                  builder: (context, state) {
                    if (state is QuestionChecked) {
                      if (state.correct) {
                        return IgnorePointer(
                            child: Icon(
                          Icons.trip_origin,
                          size: MediaQuery.of(context).size.width * 0.7,
                          color: CorrectColors.green.withAlpha(100),
                        ));
                      } else {
                        return IgnorePointer(
                            child: Icon(
                          Icons.clear,
                          size: MediaQuery.of(context).size.width * 0.7,
                          color: CorrectColors.red.withAlpha(100),
                        ));
                      }
                    } else {
                      return Text(" ");
                    }
                  },
                ),
              ])
            ]));
      } else if (state is LoadingQuestions) {
        return CommonScreens.loading(
            TranslationMap.of(context).questionsTitleText, context);
      } else {
        return CommonScreens.error(
            TranslationMap.of(context).questionsTitleText, context);
      }
    });
  }
}
