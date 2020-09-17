import 'package:equatable/equatable.dart';
import 'package:swipe_kuku/model/result.dart';

abstract class ResultState extends Equatable {
  const ResultState();
}

class CalculatingResults extends ResultState {
  @override
  List<Object> get props => [];
}

class ResultsCalculated extends ResultState {
  final Result result;
  const ResultsCalculated(this.result);

  @override
  List<Object> get props => [result];
}