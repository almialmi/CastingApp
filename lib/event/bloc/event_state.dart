import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventLoading extends EventState {}

class EventLoadSuccess extends EventState {
  final Event events;

  EventLoadSuccess([this.events]);

  @override
  List<Object> get props => [events];
}
class Eventcreationfailed extends EventState {}


class EventOperationFailure extends EventState {}

class Showremainingsuccess extends EventState {
  final Show message;
 

  Showremainingsuccess(this.message);
    
}
