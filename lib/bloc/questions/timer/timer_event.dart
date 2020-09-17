import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ResetTimer extends TimerEvent {}

class SetTimer extends TimerEvent {
  final double percentLeft;

  SetTimer(this.percentLeft);

  @override
  List<Object> get props => [percentLeft];
}

class StopTimer extends TimerEvent {}