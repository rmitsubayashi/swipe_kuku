import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_event.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_state.dart';

class QuestionValidatorBloc extends Bloc<QuestionValidatorEvent, QuestionValidatorState> {
  QuestionValidatorBloc(): super(WaitingForUserInput());

  @override
  Stream<QuestionValidatorState> mapEventToState(QuestionValidatorEvent event) async* {
    if (event is CheckAnswer) {
      yield* _mapCheckAnswerToState(event);
    } else if (event is ResetAnswer) {
      yield* _mapResetAnswerToState();
    }
  }

  Stream<QuestionValidatorState> _mapCheckAnswerToState(CheckAnswer event) async* {
    final correct = event.answer == event.question.answer;
    yield QuestionChecked(correct);
    Future.delayed(Duration(milliseconds: 300), () { add(ResetAnswer()); });
  }

  Stream<QuestionValidatorState> _mapResetAnswerToState() async* {
    yield WaitingForUserInput();
  }
}