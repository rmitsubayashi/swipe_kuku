import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:swipe_kuku/bloc/settings/settings_bloc.dart';
import 'package:swipe_kuku/bloc/settings/settings_event.dart';
import 'package:swipe_kuku/bloc/settings/settings_state.dart';
import 'package:swipe_kuku/translation/translation_map.dart';
import 'package:swipe_kuku/translation/translations.dart';
import 'package:swipe_kuku/ui/common_screens.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is SettingsLoading) {
        return CommonScreens.loading(TranslationMap.of(context).settingTitleText, context);
      } else if (state is SettingsLoaded) {
        return Scaffold(
            appBar: AppBar(
              title: Text(TranslationMap.of(context).settingTitleText),
            ),
            body: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    TranslationMap.of(context).questionCt,
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  FlatButton(
                    child: Text(state.settings.questionCt.toString()),
                    onPressed: () {
                      showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return NumberPickerDialog.integer(
                                minValue: 2,
                                // the swipe card view can't have just 1 card :(
                                maxValue: 100,
                                initialIntegerValue: state.settings.questionCt);
                          }).then((value) {
                        if (value == null || value == state.settings.questionCt) return;
                        settingsBloc.add(UpdateQuestionCt(value));
                      });
                    },
                  ),
                  Text(
                    TranslationMap.of(context).questionSpeed,
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  FlatButton(
                    child: Text(TranslationMap.of(context).questionSpeedWithUnit(state.settings.questionSpeed)),
                    onPressed: () {
                      showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return NumberPickerDialog.integer(
                                minValue: 1,
                                // the swipe card view can't have just 1 card :(
                                maxValue: 20,
                                initialIntegerValue: state.settings.questionSpeed);
                          }).then((value) {
                        if (value == null || value == state.settings.questionSpeed) return;
                        settingsBloc.add(UpdateQuestionSpeed(value));
                      });
                    },
                  ),
                  Text(
                    "音声",
                    style: TextStyle(
                        fontSize: 24
                    ),
                  ),
                  Switch(
                    value: state.settings.soundEnabled,
                    onChanged: (newEnable) {
                      if (newEnable != state.settings.soundEnabled) {
                        settingsBloc.add(UpdateSoundEnabled(newEnable));
                      }
                    },
                  ),
                  Text(
                    TranslationMap.of(context).settingsLanguageMode,
                    style: TextStyle(
                        fontSize: 24
                    ),
                  ),
                  RadioListTile(
                    title:
                        Text(Translation.toDisplayString(Translation.JAPANESE)),
                    value: Translation.JAPANESE,
                    groupValue: state.settings.translation,
                    onChanged: (value) {
                      settingsBloc.add(UpdateTranslation(value));
                    },
                  ),
                  RadioListTile(
                    title:
                        Text(Translation.toDisplayString(Translation.HIRAGANA)),
                    value: Translation.HIRAGANA,
                    groupValue: state.settings.translation,
                    onChanged: (value) {
                      settingsBloc.add(UpdateTranslation(value));
                    },
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ));
      } else {
        return CommonScreens.error(TranslationMap.of(context).settingTitleText, context);
      }
    });
  }
}
