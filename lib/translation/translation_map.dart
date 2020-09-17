import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:swipe_kuku/translation/generated/messages_all.dart';

class TranslationMap {
  final String localeName;

  TranslationMap(this.localeName);

  static Future<TranslationMap> load(Locale locale) {
    return initializeMessages(locale.toLanguageTag()).then((_) {
      return TranslationMap(locale.toLanguageTag());
    });
  }

  static TranslationMap of(BuildContext context) {
    return Localizations.of(context, TranslationMap);
  }

  String get settingTitleText {
    return Intl.message(
      'settings',
      locale: localeName
    );
  }

  String get questionCt {
    return Intl.message(
      'question ct',
      locale: localeName
    );
  }

  String get questionSpeed {
    return Intl.message(
      'question speed',
      locale: localeName
    );
  }

  String get settingsLanguageMode {
    return Intl.message(
      'language mode',
      locale: localeName
    );
  }

  // no need for plurals in japanese
  String questionSpeedWithUnit(int questionSpeed) {
    return Intl.message(
      '$questionSpeed seconds',
      name: 'questionSpeedWithUnit',
      locale: localeName,
      args: [questionSpeed]
    );

  }

  String get statsTitleText {
    return Intl.message(
      'stats',
      locale: localeName
    );
  }

  String get statsCorrectPercentageText {
    return Intl.message(
      'correct percentage',
      locale: localeName
    );
  }

  String get statsHeatMap {
    return Intl.message(
      'heat map',
      locale: localeName
    );
  }

  String get statsClickSquare {
    return Intl.message(
      'click a square',
      locale: localeName
    );
  }

  String get removeStatsText {
    return Intl.message(
      'remove stats',
      locale: localeName
    );
  }

  String get removeStatsConfirmText {
    return Intl.message(
      'are you sure',
      locale: localeName
    );
  }

  String get removeStatsYesText {
    return Intl.message(
      'yes',
      locale: localeName
    );
  }

  String get removeStatsNoText {
    return Intl.message(
      'no',
      locale: localeName
    );
  }

  String get emptyStatsText {
    return Intl.message(
      'empty stats',
      locale: localeName
    );
  }

  String get homeTitleText {
    return Intl.message(
      'swipe kuku',
      locale: localeName
    );
  }

  String get homeQuestionText {
    return Intl.message(
      'start',
      locale: localeName
    );
  }

  String get questionsTitleText {
    return Intl.message(
      'questions',
      locale: localeName
    );
  }

  String get questionsFinish {
    return Intl.message(
      'finish',
      locale: localeName
    );
  }

  String get resultsTitleText {
    return Intl.message(
      'results',
      locale: localeName
    );
  }

  String get resultsToHome {
    return Intl.message(
      'to home',
      locale: localeName
    );
  }

  String get resultsExcellent {
    return Intl.message(
      'excellent',
      locale: localeName
    );
  }

  String get resultsGreat {
    return Intl.message(
      'great',
      locale: localeName
    );
  }

  String get resultsGood {
    return Intl.message(
      'good',
      locale: localeName
    );
  }

  String get resultsCorrect {
    return Intl.message(
      'correct',
      locale: localeName
    );
  }

  String get resultsIncorrect {
    return Intl.message(
        'incorrect',
        locale: localeName
    );
  }

  String get loadingText {
    return Intl.message(
      'loading',
      locale: localeName
    );
  }

  String get errorText {
    return Intl.message(
      'error',
      locale: localeName
    );
  }
}

class TranslationMapDelegate extends LocalizationsDelegate<TranslationMap> {
  const TranslationMapDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ja', 'ja-Hiragana'].contains(locale.toLanguageTag());
  }

  @override
  Future<TranslationMap> load(Locale locale) {
    return TranslationMap.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<TranslationMap> old) => true;
  
}