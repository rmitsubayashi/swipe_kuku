import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/model/settings.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object> get props => [];
}

class SettingsLoading extends SettingsState {
  @override
  String toString() => 'Settings Loading';
}

class SettingsLoaded extends SettingsState {
  final Settings settings;
  SettingsLoaded({@required this.settings});

  @override
  List<Object> get props => [settings];
}