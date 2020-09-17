import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
}

class TimerReady extends TimerState {
  @override
  List<Object> get props => [];
}

class TimerRunning extends TimerState {
  final double percentLeft;
  TimerRunning(this.percentLeft);

  @override
  List<Object> get props => [percentLeft];
}

class TimerFinished extends TimerState {
  @override
  List<Object> get props => [];
}