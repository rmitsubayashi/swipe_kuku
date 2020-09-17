import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/bloc/questions/question_generator.dart';
import 'package:swipe_kuku/bloc/questions/questions_event.dart';
import 'package:swipe_kuku/bloc/questions/questions_state.dart';
import 'package:swipe_kuku/bloc/questions/timer/timer_bloc.dart';
import 'package:swipe_kuku/bloc/questions/timer/timer_event.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_bloc.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_event.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_state.dart';
import 'package:swipe_kuku/bloc/settings/settings_bloc.dart';
import 'package:swipe_kuku/bloc/settings/settings_state.dart';
import 'package:swipe_kuku/model/question.dart';
import 'package:swipe_kuku/model/question_record.dart';
import 'package:swipe_kuku/model/question_set.dart';
import 'package:swipe_kuku/model/settings.dart';
import 'package:swipe_kuku/repository/question_record_repository.dart';
import 'package:swipe_kuku/repository/question_set_repository.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  final SettingsBloc settingsBloc;
  StreamSubscription _settingsSubscription;
  final QuestionValidatorBloc questionValidatorBloc;
  final TimerBloc timerBloc;
  StreamSubscription questionValidatorSubscription;
  final StreamController _questionsFinishedStreamController = StreamController<bool>();
  Stream<bool> questionsFinishedStream;
  StreamSink<bool> _questionsFinishedSink;
  Settings _settings;
  final QuestionSetRepository questionSetRepository;
  final QuestionRecordRepository questionRecordRepository;
  final QuestionGenerator questionGenerator;

  final AudioCache _audioCache = AudioCache();

  QuestionSet _questionSet;
  List<Question> _questions;
  List<QuestionRecord> _questionRecords = [];

  QuestionsBloc(
    {
      @required this.settingsBloc,
      @required this.questionValidatorBloc,
      @required this.timerBloc,
      @required this.questionSetRepository,
      @required this.questionRecordRepository,
      @required this.questionGenerator
    }
  ): super(LoadingQuestions()) {
    questionsFinishedStream = _questionsFinishedStreamController.stream.asBroadcastStream();
    _questionsFinishedSink = _questionsFinishedStreamController.sink;
  }

  @override
  Stream<QuestionsState> mapEventToState(QuestionsEvent event) async* {
    if (event is GetQuestions) {
      yield* _mapGetQuestionsToState();
    } else if (event is FinishQuestions) {
      yield* _mapFinishQuestionsToState();
    }
  }

  Stream<QuestionsState> _mapGetQuestionsToState() async* {
    // have to wait until settings are loaded
    if (settingsBloc.state is SettingsLoaded) {
      // if the settings are already loaded, can't listen to it??
      _settings = (settingsBloc.state as SettingsLoaded).settings;
    } else {
      _settingsSubscription = settingsBloc.listen((state) {
        if (state is SettingsLoaded) {
          _settings = state.settings;
          add(GetQuestions());
        }
      });
      return;
    }

    final questionSet = QuestionSet(DateTime.now());
    final questionSetWithID = await questionSetRepository.insert(questionSet);
    this._questionSet = questionSetWithID;

    _questionRecords = [];
    _questions = [];
    questionGenerator.setSeed(DateTime.now().millisecondsSinceEpoch);
    for (var i=0; i<_settings.questionCt; i++) {
      _questions.add(questionGenerator.generateQuestion());
    }

    yield(QuestionsLoaded(_questions, questionSetWithID.id));

    // start the timer for the first question
    timerBloc.add(ResetTimer());
    _subscribeToQuestionValidator();
  }

  void _subscribeToQuestionValidator() {
    questionValidatorSubscription = questionValidatorBloc.listen((state) async {
      if (state is QuestionChecked) {
        final currQuestion = _questions[_questionRecords.length];
        // determine the user's answer from whether it's correct
        String userAnswer;
        if (state.correct) {
          userAnswer = currQuestion.answer;
        } else {
          userAnswer = currQuestion.wrongChoice();
        }
        final record = QuestionRecord(_questionSet, currQuestion, userAnswer, state.correct);
        _questionRecords.add(record);

        // play sound
        if (_settings.soundEnabled) {
          if (state.correct) {
            _audioCache.play("correct.wav");
          } else {
            _audioCache.play("wrong.mp3");
          }
        }

        if (_questionRecords.length == _questions.length) {
          // a new timer will begin otherwise
          timerBloc.add(StopTimer());
        } else {
          timerBloc.add(ResetTimer());
        }
      }
    });
  }

  Stream<QuestionsState> _mapFinishQuestionsToState() async* {
    timerBloc.add(StopTimer());

    if (_questionRecords.length == _questions.length) {
      // save only if completed. user can 'finish' by pressing back button as well
      for (var record in _questionRecords) {
        await questionRecordRepository.insert(record);
      }
    }
    // so the next round of questions does not already have a value
    questionValidatorBloc.add(ResetAnswer());
    _questionsFinishedSink.add(true);
    questionValidatorSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    questionValidatorSubscription?.cancel();
    _questionsFinishedStreamController.close();
    return super.close();
  }

}