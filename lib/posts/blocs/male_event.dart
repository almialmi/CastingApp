
import 'package:equatable/equatable.dart';

abstract class MaleEvent extends Equatable {
  const MaleEvent();
}

class MaleLoad extends MaleEvent {
  final String gender;
  final String cayegoryId;
  const MaleLoad(this.cayegoryId, this.gender);

  @override
  @override
  List<Object> get props => [];
}

