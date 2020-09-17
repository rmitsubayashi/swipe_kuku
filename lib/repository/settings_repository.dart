import 'package:swipe_kuku/model/settings.dart';

abstract class SettingsRepository {
  Future<Settings> getSettings();

  Future<int> getQuestionCt();
  Future<int> getQuestionSpeed();
  Future<bool> getSoundEnabled();
  Future<String> getTranslation();

  Future<bool> setQuestionCt(int newCt);
  Future<bool> setQuestionSpeed(int newSeconds);
  Future<bool> setSoundEnabled(bool enabled);
  Future<bool> setTranslation(String newTranslation);
}