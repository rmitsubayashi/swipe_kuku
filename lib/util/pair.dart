
import 'package:equatable/equatable.dart';

class Pair<E,F> extends Equatable {
  E first;
  F second;

  Pair(this.first, this.second);

  @override
  List<Object> get props => [first, second];
}