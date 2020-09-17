import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:swipe_kuku/bloc/questions/question_generator.dart';
import 'package:swipe_kuku/bloc/questions/questions_bloc.dart';
import 'package:swipe_kuku/bloc/questions/questions_event.dart';
import 'package:swipe_kuku/bloc/questions/questions_state.dart';
import 'package:swipe_kuku/model/question.dart';
import 'package:swipe_kuku/model/question_set.dart';
import 'package:swipe_kuku/repository/question_record_repository.dart';
import 'package:swipe_kuku/repository/question_set_repository.dart';
import 'package:swipe_kuku/repository/settings_repository.dart';

class MockQuestionRecordRepository extends Mock implements QuestionRecordRepository {}
class MockQuestionSetRepository extends Mock implements QuestionSetRepository {}
class MockSettingsRepository extends Mock implements SettingsRepository {}
class MockQuestionGenerator extends Mock implements QuestionGenerator {}

void main() {
  group('QuestionsBloc', () {
    QuestionsBloc questionsBloc;
    final questionRecordRepository = MockQuestionRecordRepository();
    final questionSetRepository = MockQuestionSetRepository();
    final questionGenerator = MockQuestionGenerator();
    final settingsRepository = MockSettingsRepository();

    setUp(() {
      questionsBloc = QuestionsBloc(
        questionRecordRepository: questionRecordRepository,
        questionSetRepository: questionSetRepository,
        settingsRepository: settingsRepository,
        questionGenerator: questionGenerator,
      );
      // doesn't affect any test
      when (settingsRepository.getQuestionCt()).thenAnswer((_) => Future(() => 1));
      final questionSet = QuestionSet(DateTime.now());
      // id is used to verify one test
      questionSet.id = 1;
      when (questionSetRepository.insert(any)).thenAnswer((_) => Future(() => questionSet));
    });

    tearDown(() {
      reset(questionRecordRepository);
      reset(questionSetRepository);
      reset(questionGenerator);
      reset(settingsRepository);
    });

    blocTest(
      "Generates question when invoked",
      build: () {
        final question = Question("question", "answer", ["choice1", "choice2"]);
        when (questionGenerator.generateQuestion()).thenReturn(question);
        return questionsBloc;
      },
      act: (bloc) => bloc.add(NextQuestion()),
      expect: <QuestionsState> [
        QuestionLoaded(
            Question("question", "answer", ["choice1", "choice2"])
        )
      ],
    );

    blocTest(
      "Correct answer",
      build: () {
        final question = Question("question", "answer", ["choice1", "choice2"]);
        when (questionGenerator.generateQuestion()).thenReturn(question);
        return questionsBloc;
      },
      act: (bloc) {
        bloc.add(NextQuestion());
        bloc.add(CheckAnswer("answer"));
      },
      expect: <QuestionsState> [
        QuestionLoaded(
            Question("question", "answer", ["choice1", "choice2"])
        ),
        QuestionChecked(true)
      ]
    );

    blocTest(
        "Incorrect answer",
        build: () {
          final question = Question("question", "answer", ["choice1", "choice2"]);
          when (questionGenerator.generateQuestion()).thenReturn(question);
          return questionsBloc;
        },
        act: (bloc){
          bloc.add(NextQuestion());
          bloc.add(CheckAnswer("wrong answer"));
        },
        expect: <QuestionsState> [
          QuestionLoaded(
              Question("question", "answer", ["choice1", "choice2"])
          ),
          QuestionChecked(false)
        ]
    );

    blocTest(
        "Finished question set",
        build: ()  {
          final question = Question("question", "answer", ["choice1", "choice2"]);
          when (questionGenerator.generateQuestion()).thenReturn(question);
          return questionsBloc;
        },
        act: (bloc) {
          bloc.add(NextQuestion());
          bloc.add(CheckAnswer("random answer"));
          bloc.add(NextQuestion());
        },
        expect: <QuestionsState> [
          QuestionLoaded(
              Question("question", "answer", ["choice1", "choice2"])
          ),
          QuestionChecked(false),
          QuestionsFinished(1)
        ]
    );
  });
}