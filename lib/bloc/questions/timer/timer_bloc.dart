import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/bloc/questions/timer/timer_event.dart';
import 'package:swipe_kuku/bloc/questions/timer/timer_state.dart';
import 'package:swipe_kuku/bloc/settings/settings_bloc.dart';
import 'package:swipe_kuku/bloc/settings/settings_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final SettingsBloc settingsBloc;
  StreamSubscription _settingsSubscription;
  Stream<int> _timerStream;
  StreamSubscription _timerSubscription;

  TimerBloc({@required this.settingsBloc}): super(TimerReady());

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is ResetTimer) {
      yield* _mapStartTimerToState();
    } else if (event is SetTimer) {
      yield* _mapSetTimerToState(event);
    } else if (event is StopTimer) {
      yield* _mapStopTimerToState();
    }
  }

  Stream<TimerState> _mapStartTimerToState()  async* {
    if (settingsBloc.state is SettingsLoading) {
      _settingsSubscription = settingsBloc.listen((state) {
        if (state is SettingsLoaded) {
          add(ResetTimer());
        }
      });
    }
    _timerSubscription?.cancel();
    final timerMillis = (settingsBloc.state as SettingsLoaded).settings.questionSpeed * 1000;
    // 10 fps
    _timerStream = Stream.periodic(Duration(milliseconds: 100), (event) {return event;});
    _timerSubscription = _timerStream.listen((ct) {
      final duration = ct * 100;
      final percentFinished = duration / timerMillis;
      final percentLeft = 1 - percentFinished;
      add(SetTimer(percentLeft));
    });
  }

  Stream<TimerState> _mapSetTimerToState(SetTimer event) async* {
    if (event.percentLeft <= 0) {
      yield TimerFinished();
      _timerSubscription?.cancel();
    } else {
      yield TimerRunning(event.percentLeft);
    }
  }

  Stream<TimerState> _mapStopTimerToState() async* {
    _timerSubscription?.cancel();
    yield TimerReady();
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    _timerSubscription?.cancel();

    return super.close();
  }
}