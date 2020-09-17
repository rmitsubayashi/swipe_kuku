import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {
  @override
  String toString() => 'Load Settings';
}

class UpdateQuestionCt extends SettingsEvent {
  final int questionCt;
  UpdateQuestionCt(this.questionCt);

  @override
  String toString() => 'Update Question Count { settings: $questionCt }';
}

class UpdateQuestionSpeed extends SettingsEvent {
  final int questionSpeed;
  UpdateQuestionSpeed(this.questionSpeed);

  @override
  String toString() => 'Update Question Speed { settings: $questionSpeed }';
}

class UpdateSoundEnabled extends SettingsEvent {
  final bool soundEnabled;
  UpdateSoundEnabled(this.soundEnabled);

  @override
  String toString() => 'Update Sound Enabled { soundEnabled: $soundEnabled }';
}

class UpdateTranslation extends SettingsEvent {
  final String translation;
  UpdateTranslation(this.translation);

  @override
  String toString() => 'Update Translation { settings: $translation }';
}

