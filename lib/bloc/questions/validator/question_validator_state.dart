abstract class QuestionValidatorState {
  const QuestionValidatorState();
}

class WaitingForUserInput extends QuestionValidatorState {
}

class QuestionChecked extends QuestionValidatorState {
  final bool correct;

  const QuestionChecked(this.correct);
}