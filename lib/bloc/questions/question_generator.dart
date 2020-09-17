import 'package:swipe_kuku/model/question.dart';
import 'package:swipe_kuku/util/pair.dart';

abstract class QuestionGenerator {
  void setSeed(int seed);

  Question generateQuestion();

  static String formatQuestion(int first, int second) {
    return "$first x $second";
  }

  static Pair<int, int> fromQuestion(String question) {
    final split = question.split(' x ');
    if (split.length < 2) return null;
    return Pair(int.parse(split[0]), int.parse(split[1]));
  }
}
