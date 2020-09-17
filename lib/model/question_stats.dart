import 'package:equatable/equatable.dart';
import 'package:swipe_kuku/util/pair.dart';

class QuestionStats extends Equatable {
  final Pair<int, int> question;
  final int correctPercentage;
  final int totalCt;

  QuestionStats(this.question, this.correctPercentage, this.totalCt);

  @override
  List<Object> get props => [question, correctPercentage, totalCt];
}