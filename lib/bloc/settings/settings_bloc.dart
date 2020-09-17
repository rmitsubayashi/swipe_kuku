import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/bloc/settings/settings_event.dart';
import 'package:swipe_kuku/bloc/settings/settings_state.dart';
import 'package:swipe_kuku/repository/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({@required this.settingsRepository}): super(SettingsLoading());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is LoadSettings) {
      yield* _mapLoadSettingsToState();
    } else if (event is UpdateQuestionCt) {
      yield* _mapUpdateQuestionCtToState(event);
    } else if (event is UpdateQuestionSpeed) {
      yield* _mapUpdateQuestionSpeedToState(event);
    } else if (event is UpdateSoundEnabled) {
      yield* _mapUpdateSoundEnabledToState(event);
    } else if (event is UpdateTranslation) {
      yield* _mapUpdateTranslationToState(event);
    }
  }

  Stream<SettingsState> _mapLoadSettingsToState() async* {
    final settings = await this.settingsRepository.getSettings();
    yield SettingsLoaded(settings: settings);
  }

  Stream<SettingsState> _mapUpdateQuestionCtToState(UpdateQuestionCt event) async* {
    await this.settingsRepository.setQuestionCt(event.questionCt);
    yield* _mapLoadSettingsToState();
  }

  Stream<SettingsState> _mapUpdateQuestionSpeedToState(UpdateQuestionSpeed event) async* {
    await this.settingsRepository.setQuestionSpeed(event.questionSpeed);
    yield* _mapLoadSettingsToState();
  }

  Stream<SettingsState> _mapUpdateSoundEnabledToState(UpdateSoundEnabled event) async* {
    await this.settingsRepository.setSoundEnabled(event.soundEnabled);
    yield* _mapLoadSettingsToState();
  }

  Stream<SettingsState> _mapUpdateTranslationToState(UpdateTranslation event) async* {
    await this.settingsRepository.setTranslation(event.translation);
    yield* _mapLoadSettingsToState();
  }
}