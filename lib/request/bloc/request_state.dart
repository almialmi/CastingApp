import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object> get props => [];
}

class RequestLoading extends RequestState {}

class RequestLoadSuccess extends RequestState {
  final Request requests;

  RequestLoadSuccess([this.requests]);

  @override
  List<Object> get props => [requests];
}

class RequestOperationFailure extends RequestState {}
