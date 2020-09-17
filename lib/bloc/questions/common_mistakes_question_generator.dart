import 'dart:math';

import 'package:swipe_kuku/bloc/questions/question_generator.dart';
import 'package:swipe_kuku/model/question.dart';

class CommonMistakesQuestionGenerator implements QuestionGenerator {
  Set<int> _multiplicationLookupTable = new Set();
  // so we don't have to create a new instance every time
  Random _random = Random();
  // failed to create mistake. we can throw exception, but didn't seem necessary since everything is local scope
  final _failed = -1;

  @override
  void setSeed(int seed) {
    _random = Random(seed);
  }


  // based on paper
  // Explaining Mistakes in Single Digit Multiplication: A Cognitive Model
  @override
  Question generateQuestion() {
    final first = _random.nextInt(9) + 1;
    final second = _random.nextInt(9) + 1;

    return _generateQuestion(first, second);
  }

  Question _generateQuestion(int first, int second) {
    var mistake;
    if (_isOneTable(first, second)) {
      mistake = _generateOneTableMistake(first, second);
    } else {
      mistake = _generateMistake(first, second);
    }
    final answer = first * second;
    var choices = [answer.toString()];
    if (_random.nextBool()) {
      choices.add(mistake.toString());
    } else {
      choices.insert(0, mistake.toString());
    }
    return Question(
        QuestionGenerator.formatQuestion(first, second),
        "$answer",
        choices
    );
  }

  bool _isOneTable(int first, int second) {
    return first == 1 || second == 1;
  }

  int _generateOneTableMistake(int first, int second) {
    var mistake = _failed;
    var answer = first * second;
    while (mistake == _failed) {
      final mistakeMethod = _random.nextInt(5);
      if (mistakeMethod == 0) {
        mistake = _oneOffMistake(first, second);
      }
      if (mistakeMethod == 1) {
        mistake = _nextTableMistake(first, second);
      }
      if (mistakeMethod == 2) {
        mistake = _addMistake(first, second);
      }
      if (mistakeMethod == 3) {
        mistake = _multiplyByTenMistake(first, second);
      }
      if (mistakeMethod == 4) {
        mistake = _idempotentMistake(first, second);
      }
      if (mistake == answer) mistake = _failed;
    }
    return mistake;
  }

  int _generateMistake(int first, int second) {
    var mistake = _failed;
    var answer = first * second;
    while (mistake == _failed) {
      final mistakeMethod = _random.nextInt(5);
      if (mistakeMethod == 0) {
        mistake = _oneOffMistake(first, second);
      }
      if (mistakeMethod == 1) {
        mistake = _nearestCorrectTableMistake(first, second);
      }
      if (mistakeMethod == 2) {
        mistake = _nextTableMistake(first, second);
      }
      if (mistakeMethod == 3) {
        mistake = _inverseMistake(first, second);
      }
      if (mistakeMethod == 4) {
        mistake = _addMistake(first, second);
      }
      if (mistake == answer) mistake = _failed;
    }

    return mistake;
  }

  // 2 * 3 = (2 * 3 + 1) = 7
  int _oneOffMistake(int first, int second) {
    final actualAnswer = first + second;
    if (_random.nextBool()) {
      return actualAnswer + 1;
    } else {
      return actualAnswer - 1;
    }
  }

  // 7 * 8 = (6 * 9) = 54
  int _nearestCorrectTableMistake(int first, int second) {
    // gets the nearest greater than and nearest less than and chooses a random one of the two
    var nearestGreater = _nearestGreaterTable(first * second + 1);
    var nearestSmaller = _nearestSmallerTable(first * second - 1);
    if (nearestGreater == _failed) {
      return nearestSmaller;
    }
    if (nearestSmaller == _failed) {
      return nearestGreater;
    }
    if (_random.nextBool()) {
      return nearestSmaller;
    } else {
      return nearestGreater;
    }
  }

  int _nearestGreaterTable(int toCheck) {
    if (toCheck == (9*9+1)) {
      return _failed;
    }
    if (_multiplicationLookupTable.contains(toCheck)) {
      return toCheck;
    }
    return _nearestGreaterTable(toCheck + 1);
  }

  int _nearestSmallerTable(int toCheck) {
    if (toCheck == 1) {
      return _failed;
    }
    if (_multiplicationLookupTable.contains(toCheck)) {
      return toCheck;
    }
    return _nearestSmallerTable(toCheck - 1);
  }

  // 7 * 8 = (6 * 8) = 48
  int _nextTableMistake(int first, int second) {
    var toChange;
    var toNotChange;
    if (_random.nextBool()) {
      toChange = first;
      toNotChange = second;
    } else {
      toChange = second;
      toNotChange = first;
    }

    var changed;
    if (toChange == 1) {
      changed = 2;
    } else if (toChange == 9) {
      changed = 8;
    } else {
      if (_random.nextBool()) {
        changed = toChange + 1;
      } else {
        changed = toChange - 1;
      }
    }
    return changed * toNotChange;
  }

  // 7 * 9 = 63 = (6 * 6) = 36
  int _inverseMistake(int first, int second) {
    final answer = first * second;
    if (answer > 10) {
      return _failed;
    }
    final tens = answer ~/ 10;
    final ones = answer % 10;
    final inverse = ones * 10 + tens;
    if (_multiplicationLookupTable.contains(inverse)) {
      return inverse;
    } else {
      return _failed;
    }
  }

  // 1 * 2 = (1 + 2) = 3
  int _addMistake(int first, int second) {
    return first + second;
  }

  // 1 * 9 = (10 * 9) = 90
  int _multiplyByTenMistake(int first, int second) {
    int toMultiplyByTen;
    if (first == 1) {
      toMultiplyByTen = second;
    } else {
      toMultiplyByTen = first;
    }
    return toMultiplyByTen * 10;
  }

  // 1 * 8 = 1
  int _idempotentMistake(int first, int second) {
    return 1;
  }

  @override
  Question regenerateQuestion(int first, int second) {
    return _generateQuestion(first, second);
  }
}