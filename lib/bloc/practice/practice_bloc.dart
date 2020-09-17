import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audio_cache.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/bloc/practice/practice_event.dart';
import 'package:swipe_kuku/bloc/practice/practice_state.dart';
import 'package:swipe_kuku/bloc/questions/question_generator.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_bloc.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_event.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_state.dart';
import 'package:swipe_kuku/bloc/settings/settings_bloc.dart';
import 'package:swipe_kuku/bloc/settings/settings_state.dart';
import 'package:swipe_kuku/model/question.dart';
import 'package:swipe_kuku/model/settings.dart';

class PracticeBloc extends Bloc<PracticeEvent, PracticeState> {
  final SettingsBloc settingsBloc;
  StreamSubscription _settingsSubscription;
  final QuestionValidatorBloc questionValidatorBloc;
  StreamSubscription _questionValidatorSubscription;
  Settings _settings;
  final QuestionGenerator questionGenerator;

  final AudioCache _audioCache = AudioCache();

  ListQueue<Question> _questions;

  PracticeBloc(
    {
      @required this.settingsBloc,
      @required this.questionValidatorBloc,
      @required this.questionGenerator
    }
  ): super(LoadingPracticeQuestions());

  @override
  Stream<PracticeState> mapEventToState(PracticeEvent event) async* {
    if (event is GetPracticeQuestions) {
      yield* _mapGetPracticeQuestionsToState();
    } else if (event is FinishPracticeQuestions) {
      yield* _mapFinishPracticeQuestionsToState();
    } else if (event is UpdatePracticeQuestions) {
      yield* _mapUpdatePracticeQuestionsToState();
    }
  }

  Stream<PracticeState> _mapGetPracticeQuestionsToState() async* {
    // have to wait until settings are loaded
    if (settingsBloc.state is SettingsLoaded) {
      // if the settings are already loaded, can't listen to it??
      _settings = (settingsBloc.state as SettingsLoaded).settings;
    } else {
      _settingsSubscription = settingsBloc.listen((state) {
        if (state is SettingsLoaded) {
          _settings = state.settings;
          add(GetPracticeQuestions());
        }
      });
      return;
    }

    _questions = ListQueue(_settings.questionCt);
    questionGenerator.setSeed(DateTime.now().millisecondsSinceEpoch);
    for (var i=0; i<_settings.questionCt; i++) {
      _questions.add(questionGenerator.generateQuestion());
    }
    yield(PracticeQuestionsLoaded(_questions.toList(growable: false)));

    _subscribeToQuestionValidator();

  }

  void _subscribeToQuestionValidator() {
    _questionValidatorSubscription = questionValidatorBloc.listen((state) {
      if (state is QuestionChecked) {
        final currQuestion = _questions.removeFirst();
        if (!state.correct) {
          // the user will get the same question with differerent choices
          final questionNumbers = QuestionGenerator.fromQuestion(currQuestion.question);
          final newQuestion = questionGenerator.regenerateQuestion(questionNumbers.first, questionNumbers.second);
          _questions.add(newQuestion);

          add(UpdatePracticeQuestions());
        }

        // play sound
        if (_settings.soundEnabled) {
          if (state.correct) {
            _audioCache.play("correct.wav");
          } else {
            _audioCache.play("wrong.mp3");
          }
        }

      }
    });
  }

  Stream<PracticeState> _mapFinishPracticeQuestionsToState() async* {
    questionValidatorBloc.add(ResetAnswer());
    _questionValidatorSubscription?.cancel();
  }

  Stream<PracticeState> _mapUpdatePracticeQuestionsToState() async* {
    // hack to bypass ui restrictions...
    // we need the tinder swipe  widget to know it should update,
    // but it won't if the card count is the same (it will be)..
    // so create an extra card and force it to update once,
    // then emit the actual question list.
    final copy = _questions.toList();
    copy.add(Question("","",["",""]));
    yield PracticeQuestionsLoaded(copy);
    yield await Future.delayed(Duration(milliseconds: 2), () {
      return PracticeQuestionsLoaded(_questions.toList(growable: false));
    });
    // fyi I tried increasing question ct indefinitely instead of popping it and adding it to the bottom,
    // but in that case the index of the tinder card widget resets to 0..
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    _questionValidatorSubscription?.cancel();
    return super.close();
  }
}