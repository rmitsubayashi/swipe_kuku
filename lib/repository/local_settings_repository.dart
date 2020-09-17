import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_kuku/model/settings.dart';
import 'package:swipe_kuku/repository/settings_repository.dart';
import 'package:swipe_kuku/translation/translations.dart';

class LocalSettingsRepository implements SettingsRepository {
  @override
  Future<Settings> getSettings() async {
    final questionCt = await getQuestionCt();
    final questionSpeed = await getQuestionSpeed();
    final soundEnabled = await getSoundEnabled();
    final translation = await getTranslation();
    return Settings(
        questionCt, questionSpeed, soundEnabled, translation
    );
  }

  @override
  Future<int> getQuestionCt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("question_ct") ?? 10;
  }

  @override
  Future<int> getQuestionSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("question_speed") ?? 5;
  }

  @override
  Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("sound") ?? true;
  }

  @override
  Future<String> getTranslation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("translation") ?? Translation.JAPANESE;
  }

  @override
  Future<bool> setQuestionCt(int newCt) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt("question_ct", newCt);
  }

  @override
  Future<bool> setQuestionSpeed(int newSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt("question_speed", newSeconds);
  }

  @override
  Future<bool> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool("sound", enabled);
  }

  @override
  Future<bool> setTranslation(String newTranslation) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("translation", newTranslation);
  }
}