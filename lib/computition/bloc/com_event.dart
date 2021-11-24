
import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

abstract class CompEvent extends Equatable {
  const CompEvent();
}

class CompLoad extends CompEvent {
  final String id;
  const CompLoad(this.id);

  @override
  @override
  List<Object> get props => [];
}

class WinnersLoad extends CompEvent {
  final String id;
  const WinnersLoad(this.id);

  @override
  @override
  List<Object> get props => [];
}

class CompCreate extends CompEvent {
  final COmputationPost comp;

  const CompCreate(this.comp);
  @override
  List<Object> get props => [comp];

  @override
  String toString() => 'computation created {post: $comp} ';
}

class CompDelete extends CompEvent {
  //final RequestElement request;
  final String comp;
  final String id;

  const CompDelete(this.comp, this.id);

  @override
  List<Object> get props => [comp];

  @override
  toString() => 'post Deleted {post: $comp}';
}

class UpdateJudgePoint extends CompEvent {
  final String id;
  final int judgePoints;
  const UpdateJudgePoint(this.id, this.judgePoints);
  @override
  List<Object> get props => [judgePoints];

  @override
  toString() => 'post updated {post: $judgePoints}';
}
