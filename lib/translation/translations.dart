class Translation {
  static const JAPANESE = "ja";
  static const HIRAGANA = "ja-Hiragana";
  static const HIRAGANA_LANGUAGE_CODE = "ja";
  static const HIRAGANA_SCRIPT_CODE = "Hiragana";

  static String toDisplayString(String translation) {
    if (translation == JAPANESE) {
      return "漢字";
    } else {
      return "ひらがな";
    }
  }
}