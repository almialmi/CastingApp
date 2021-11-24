import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

class CompState extends Equatable {
  const CompState();

  @override
  List<Object> get props => [];
}

class CompLoading extends CompState {}

class CompLoadSuccess extends CompState {
  final Computation comps;

  CompLoadSuccess([this.comps]);

  @override
  List<Object> get props => [comps];
}

class WinnersLoadSuccess extends CompState {
  final Winners comps;

  WinnersLoadSuccess([this.comps]);

  @override
  List<Object> get props => [comps];
}

class SetJudgePoint extends CompState {
  final String message;

  SetJudgePoint([this.message]);

  @override
  List<Object> get props => [message];
}

class CompOperationFailure extends CompState {}
