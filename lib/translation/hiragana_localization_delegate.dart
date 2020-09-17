import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart' as intl;
import 'package:meta/meta.dart';
import 'package:swipe_kuku/translation/translations.dart';

class JaHiraganaMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const JaHiraganaMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == Translation.HIRAGANA_LANGUAGE_CODE && locale.scriptCode == Translation.HIRAGANA_SCRIPT_CODE;

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());
    await intl.initializeDateFormatting(localeName, null);
    return SynchronousFuture<MaterialLocalizations>(
      MaterialLocalizationJaHiragana(
        localeName: localeName,
        fullYearFormat: intl.DateFormat.y(locale.languageCode),
        compactDateFormat: intl.DateFormat.yMd(locale.languageCode),
        shortDateFormat: intl.DateFormat.yMMMd(locale.languageCode),
        mediumDateFormat: intl.DateFormat.MMMEd(locale.languageCode),
        longDateFormat: intl.DateFormat.yMMMMEEEEd(locale.languageCode),
        yearMonthFormat: intl.DateFormat.yMMMM(locale.languageCode),
        shortMonthDayFormat: intl.DateFormat.MMMd(locale.languageCode),
        decimalFormat: intl.NumberFormat.decimalPattern(locale.languageCode),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', locale.languageCode)
      ),
    );
  }

  @override
  bool shouldReload(JaHiraganaMaterialLocalizationsDelegate old) => false;
}
class Tst extends MaterialLocalizationJa {}


/// Copied translations for Japanese (`ja`).
class MaterialLocalizationJaHiragana extends GlobalMaterialLocalizations {
  /// Create an instance of the translation bundle for Japanese.
  ///
  /// For details on the meaning of the arguments, see [GlobalMaterialLocalizations].
  const MaterialLocalizationJaHiragana({
    String localeName = Translation.HIRAGANA,
    @required intl.DateFormat fullYearFormat,
    @required intl.DateFormat compactDateFormat,
    @required intl.DateFormat shortDateFormat,
    @required intl.DateFormat mediumDateFormat,
    @required intl.DateFormat longDateFormat,
    @required intl.DateFormat yearMonthFormat,
    @required intl.DateFormat shortMonthDayFormat,
    @required intl.NumberFormat decimalFormat,
    @required intl.NumberFormat twoDigitZeroPaddedFormat,
  }) : super(
    localeName: localeName,
    fullYearFormat: fullYearFormat,
    compactDateFormat: compactDateFormat,
    shortDateFormat: shortDateFormat,
    mediumDateFormat: mediumDateFormat,
    longDateFormat: longDateFormat,
    yearMonthFormat: yearMonthFormat,
    shortMonthDayFormat: shortMonthDayFormat,
    decimalFormat: decimalFormat,
    twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
  );

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
  JaHiraganaMaterialLocalizationsDelegate();

  @override
  String get aboutListTileTitleRaw => '\$applicationName について';

  @override
  String get alertDialogLabel => 'つうち';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get backButtonTooltip => 'もどる';

  @override
  String get calendarModeButtonLabel => 'カレンダーにきりかえ';

  @override
  String get cancelButtonLabel => 'キャンセル';

  @override
  String get closeButtonLabel => 'とじる';

  @override
  String get closeButtonTooltip => 'とじる';

  @override
  String get collapsedIconTapHint => 'てんかい';

  @override
  String get continueButtonLabel => 'ぞっこう';

  @override
  String get copyButtonLabel => 'コピー';

  @override
  String get cutButtonLabel => 'きりとり';

  @override
  String get dateHelpText => 'yyyy/mm/dd';

  @override
  String get dateInputLabel => 'ひづけをにゅうりょく';

  @override
  String get dateOutOfRangeLabel => 'はんいがいです。';

  @override
  String get datePickerHelpText => 'ひづけのせんたく';

  @override
  String get dateRangeEndDateSemanticLabelRaw => 'しゅうりょうび \$fullDate';

  @override
  String get dateRangeEndLabel => 'しゅうりょうび';

  @override
  String get dateRangePickerHelpText => 'きかんのせんたく';

  @override
  String get dateRangeStartDateSemanticLabelRaw => 'かいしび \$fullDate';

  @override
  String get dateRangeStartLabel => 'かいしび';

  @override
  String get dateSeparator => '/';

  @override
  String get deleteButtonTooltip => 'さくじょ';

  @override
  String get dialModeButtonLabel => 'ダイヤルせんたくツール モードにきりかえます';

  @override
  String get dialogLabel => 'ダイアログ';

  @override
  String get drawerLabel => 'ナビゲーション メニュー';

  @override
  String get expandedIconTapHint => 'おりたたむ';

  @override
  String get hideAccountsLabel => 'アカウントをひひょうじ';

  @override
  String get inputDateModeButtonLabel => 'にゅうりょくにきりかえ';

  @override
  String get inputTimeModeButtonLabel => 'テキストにゅうりょくモードにきりかえます';

  @override
  String get invalidDateFormatLabel => 'けいしきがむこうです。';

  @override
  String get invalidDateRangeLabel => 'はんいがむこうです。';

  @override
  String get invalidTimeLabel => 'ゆうこうなじこくをにゅうりょくしてください';

  @override
  String get licensesPackageDetailTextFew => null;

  @override
  String get licensesPackageDetailTextMany => null;

  @override
  String get licensesPackageDetailTextOne => 'ライセンス: 1 けん';

  @override
  String get licensesPackageDetailTextOther => 'ライセンス: \$licenseCount けん';

  @override
  String get licensesPackageDetailTextTwo => null;

  @override
  String get licensesPackageDetailTextZero => 'No licenses';

  @override
  String get licensesPageTitle => 'ライセンス';

  @override
  String get modalBarrierDismissLabel => 'とじる';

  @override
  String get moreButtonTooltip => 'そのた';

  @override
  String get nextMonthTooltip => 'らいげつ';

  @override
  String get nextPageTooltip => 'つぎのページ';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get openAppDrawerTooltip => 'ナビゲーション メニューをひらく';

  @override
  String get pageRowsInfoTitleRaw => '\$firstRow - \$lastRow ぎょう（ごうけい \$rowCount ぎょう）';

  @override
  String get pageRowsInfoTitleApproximateRaw => '\$firstRow – \$lastRow ぎょう（ごうけいやく \$rowCount ぎょう）';

  @override
  String get pasteButtonLabel => 'はりつけ';

  @override
  String get popupMenuLabel => 'ポップアップ メニュー';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get previousMonthTooltip => 'ぜんげつ';

  @override
  String get previousPageTooltip => 'まえのページ';

  @override
  String get refreshIndicatorSemanticLabel => 'こうしん';

  @override
  String get remainingTextFieldCharacterCountFew => null;

  @override
  String get remainingTextFieldCharacterCountMany => null;

  @override
  String get remainingTextFieldCharacterCountOne => 'のこり 1 もじ（はんかくそうとう）';

  @override
  String get remainingTextFieldCharacterCountOther => 'のこり \$remainingCount もじ（はんかくそうとう）';

  @override
  String get remainingTextFieldCharacterCountTwo => null;

  @override
  String get remainingTextFieldCharacterCountZero => 'TBD';

  @override
  String get reorderItemDown => 'したにいどう';

  @override
  String get reorderItemLeft => 'ひだりにいどう';

  @override
  String get reorderItemRight => 'みぎにいどう';

  @override
  String get reorderItemToEnd => 'さいごにいどう';

  @override
  String get reorderItemToStart => 'せんとうにいどう';

  @override
  String get reorderItemUp => 'うえにいどう';

  @override
  String get rowsPerPageTitle => 'ページあたりのぎょうすう:';

  @override
  String get saveButtonLabel => 'ほぞん';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.dense;

  @override
  String get searchFieldLabel => 'けんさく';

  @override
  String get selectAllButtonLabel => 'すべてせんたく';

  @override
  String get selectYearSemanticsLabel => 'ねんをせんたく';

  @override
  String get selectedRowCountTitleFew => null;

  @override
  String get selectedRowCountTitleMany => null;

  @override
  String get selectedRowCountTitleOne => '1 けんのアイテムをせんたくちゅう';

  @override
  String get selectedRowCountTitleOther => '\$selectedRowCount けんのアイテムをせんたくちゅう';

  @override
  String get selectedRowCountTitleTwo => null;

  @override
  String get selectedRowCountTitleZero => null;

  @override
  String get showAccountsLabel => 'アカウントをひょうじ';

  @override
  String get showMenuTooltip => 'メニューをひょうじ';

  @override
  String get signedInLabel => 'ログインちゅう';

  @override
  String get tabLabelRaw => 'タブ: \$tabIndex/\$tabCount';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.H_colon_mm;

  @override
  String get timePickerDialHelpText => 'じこくのせんたく';

  @override
  String get timePickerHourLabel => 'じ';

  @override
  String get timePickerHourModeAnnouncement => 'じかんをせんたく';

  @override
  String get timePickerInputHelpText => 'じこくのにゅうりょく';

  @override
  String get timePickerMinuteLabel => 'ふん';

  @override
  String get timePickerMinuteModeAnnouncement => 'ふんをせんたく';

  @override
  String get unspecifiedDate => 'ひづけ';

  @override
  String get unspecifiedDateRange => 'きかん';

  @override
  String get viewLicensesButtonLabel => 'ライセンスをひょうじ';
}