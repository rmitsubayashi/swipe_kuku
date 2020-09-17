import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final int questionCt;
  final int questionSpeed;
  final bool soundEnabled;
  final String translation;
  
  Settings(this.questionCt, this.questionSpeed, this.soundEnabled, this.translation);

  @override
  List<Object> get props => [questionCt, questionSpeed, soundEnabled, translation];

}