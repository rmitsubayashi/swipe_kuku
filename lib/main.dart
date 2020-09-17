import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:swipe_kuku/bloc/practice/practice_bloc.dart';
import 'package:swipe_kuku/bloc/questions/common_mistakes_question_generator.dart';
import 'package:swipe_kuku/bloc/questions/questions_bloc.dart';
import 'package:swipe_kuku/bloc/questions/timer/timer_bloc.dart';
import 'package:swipe_kuku/bloc/questions/validator/question_validator_bloc.dart';
import 'package:swipe_kuku/bloc/result/result_bloc.dart';
import 'package:swipe_kuku/bloc/settings/settings_bloc.dart';
import 'package:swipe_kuku/bloc/settings/settings_event.dart';
import 'package:swipe_kuku/bloc/settings/settings_state.dart';
import 'package:swipe_kuku/bloc/stats/selected_question/selected_question_bloc.dart';
import 'package:swipe_kuku/bloc/stats/stats_bloc.dart';
import 'package:swipe_kuku/bloc/stats/stats_event.dart';
import 'file:///C:/Users/ryomi/Documents/android/swipe_kuku/lib/translation/hiragana_localization_delegate.dart';
import 'package:swipe_kuku/repository/local_settings_repository.dart';
import 'package:swipe_kuku/repository/sqlite_local_database.dart';
import 'package:swipe_kuku/repository/sqlite_question_record_repository.dart';
import 'package:swipe_kuku/repository/sqlite_question_set_repository.dart';
import 'package:swipe_kuku/translation/translation_map.dart';
import 'package:swipe_kuku/translation/translations.dart';
import 'package:swipe_kuku/ui/home_screen.dart';
import 'package:swipe_kuku/ui/practice_finished_screen.dart';
import 'package:swipe_kuku/ui/practice_screen.dart';
import 'package:swipe_kuku/ui/questions_screen.dart';
import 'package:swipe_kuku/ui/result_screen.dart';
import 'package:swipe_kuku/ui/routes.dart';
import 'package:swipe_kuku/ui/settings_screen.dart';
import 'package:swipe_kuku/ui/stats_screen.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SettingsBloc>(
        create: (context) =>
            SettingsBloc(settingsRepository: LocalSettingsRepository())
              ..add(LoadSettings()),
      ),
      BlocProvider<QuestionValidatorBloc> (
        create: (context) =>
          QuestionValidatorBloc(),
      ),
      BlocProvider<TimerBloc> (
        create: (context) =>
          TimerBloc(
            settingsBloc: BlocProvider.of<SettingsBloc>(context),
          ),
      ),
      BlocProvider<QuestionsBloc>(
        create: (context) =>
            QuestionsBloc(
              questionValidatorBloc: BlocProvider.of<QuestionValidatorBloc>(context),
              timerBloc: BlocProvider.of<TimerBloc>(context),
              settingsBloc: BlocProvider.of<SettingsBloc>(context),
              questionSetRepository: SqliteQuestionSetRepository(LocalDatabase.getInstance()),
              questionRecordRepository: SqliteQuestionRecordRepository(LocalDatabase.getInstance()),
              questionGenerator: CommonMistakesQuestionGenerator()
            ),
      ),
      BlocProvider<PracticeBloc>(
        create: (context) =>
            PracticeBloc(
              questionValidatorBloc: BlocProvider.of<QuestionValidatorBloc>(context),
              questionGenerator: CommonMistakesQuestionGenerator(),
              settingsBloc: BlocProvider.of<SettingsBloc>(context)
            ),
      ),
      BlocProvider<ResultBloc>(
        create: (context) =>
            ResultBloc(
              questionRecordRepository: SqliteQuestionRecordRepository(LocalDatabase.getInstance()),
              questionsBloc: BlocProvider.of<QuestionsBloc>(context)
            )
      ),
      BlocProvider<SelectedQuestionBloc>(
        create: (context) =>
          SelectedQuestionBloc(
            questionRecordRepository: SqliteQuestionRecordRepository(LocalDatabase.getInstance()),
          ),
      ),
      BlocProvider<StatsBloc>(
        create: (context) =>
          StatsBloc(
            questionRecordRepository: SqliteQuestionRecordRepository(LocalDatabase.getInstance()),
            questionsBloc: BlocProvider.of<QuestionsBloc>(context),
            selectedQuestionBloc: BlocProvider.of<SelectedQuestionBloc>(context),
          ) .. add(LoadStats())
      ),
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      // the user can set his locale in the settings
      Locale locale;
      if (state is SettingsLoaded) {
        if (state.settings.translation == Translation.HIRAGANA) {
          locale = Locale.fromSubtags(languageCode: Translation.HIRAGANA_LANGUAGE_CODE, scriptCode: Translation.HIRAGANA_SCRIPT_CODE);
        } else {
          locale = Locale(Translation.JAPANESE);
        }
      } else {
        locale = Locale(Translation.JAPANESE);
      }
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(0, 147, 148, 1.0),
          primaryColorDark: Color.fromRGBO(0, 98, 112, 1.0),
          primaryColorLight: Color.fromRGBO(0, 224, 199, 1.0),
          accentColor: Color.fromRGBO(255, 135, 73, 1.0),
        ),
        home: HomeScreen(),
        routes: <String, WidgetBuilder> {
          Routes.home: (BuildContext context) => HomeScreen(),
          Routes.questions: (BuildContext context) => QuestionsScreen(),
          Routes.practice: (BuildContext context) => PracticeScreen(),
          Routes.stats: (BuildContext context) => StatsScreen(),
          Routes.results: (BuildContext context) => ResultScreen(),
          Routes.practiceFinished: (BuildContext context) => PracticeFinishedScreen(),
          Routes.settings: (BuildContext context) => SettingsScreen(),
        },
        localizationsDelegates: [
          const TranslationMapDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MaterialLocalizationJaHiragana.delegate
        ],
        supportedLocales: [
          const Locale(Translation.JAPANESE, ''),
          const Locale.fromSubtags(
              languageCode: Translation.HIRAGANA_LANGUAGE_CODE,
              scriptCode: Translation.HIRAGANA_SCRIPT_CODE),
        ],
        locale: locale,
      );
    });
  }
}
