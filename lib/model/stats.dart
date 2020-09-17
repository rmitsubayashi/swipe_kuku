import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Stats extends Equatable {
  // 9 x 9
  final List<List<Heat>> questionHeatMap;
  final int correctPercentage;
  final CorrectPercentageGrade correctPercentageGrade;

  Stats({@required this.questionHeatMap, @required this.correctPercentage, @required this.correctPercentageGrade}):
      assert(questionHeatMap.length == 9); // don't know how to do assertion on each row??

  @override
  List<Object> get props => [questionHeatMap, correctPercentage, correctPercentageGrade];
}

enum Heat {
  // hot = bad, cold = good
  // none = no data available
  HOT, WARM, COOL, COLD, NONE
}

enum CorrectPercentageGrade {
  EXCELLENT,
  GREAT,
  GOOD
}