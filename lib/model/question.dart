import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Question extends Equatable {
  final String question;
  final String answer;
  final List<String> choices;

  Question(this.question, this.answer, this.choices);

  @override
  List<Object> get props => [question, answer, choices];

  String wrongChoice() {
    if (choices[0] == answer) {
      return choices[1];
    } else {
      return choices[0];
    }
  }
}