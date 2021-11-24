import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();
}

class MyRequestLoad extends RequestEvent {
  
  const MyRequestLoad();

  @override
  @override
  List<Object> get props => [];
}

class RequestLoad extends RequestEvent {
  const RequestLoad();

  @override
  @override
  List<Object> get props => [];
}

class RequestCreate extends RequestEvent {
  final RequestElement request;

  const RequestCreate(this.request);
  @override
  List<Object> get props => [request];

  @override
  String toString() => 'post created {post: $request} ';
}

class RequestUpdate extends RequestEvent {
  final RequestElement element;

  const RequestUpdate(this.element);

  @override
  List<Object> get props => [element];

  @override
  String toString() => 'Request Updated {post: $element}';
}

class RequestDelete extends RequestEvent {
  //final RequestElement request;
  final String request;

  const RequestDelete(this.request);

  @override
  List<Object> get props => [request];

  @override
  toString() => 'post Deleted {post: $request}';
}
