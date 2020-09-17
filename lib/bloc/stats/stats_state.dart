import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:swipe_kuku/model/stats.dart';

abstract class StatsState extends Equatable {
  const StatsState();
  @override
  List<Object> get props => [];
}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final Stats stats;
  StatsLoaded({@required this.stats});

  @override
  List<Object> get props => [stats];
}

class StatsEmpty extends StatsState {}