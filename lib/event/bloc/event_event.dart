import 'dart:io';

import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();
}

class EventLoad extends EventEvent {
  final String bolean;
  //final String cayegoryId;
  const EventLoad(this.bolean);

  @override
  @override
  List<Object> get props => [];
}

class EventCreate extends EventEvent {
  final File image;
  final EventElement event;

  const EventCreate(this.event, this.image);
  @override
  List<Object> get props => [event];

  @override
  String toString() => 'post created {post: $event} ';
}

class EventUpdate extends EventEvent {
  final EventElement event;
  final File image;

  const EventUpdate(this.event, this.image);

  @override
  List<Object> get props => [event];

  @override
  String toString() => 'Post Updated {post: $event}';
}

class EventUpdatenotPic extends EventEvent {
  final EventElement event;
  const EventUpdatenotPic(this.event);
  @override
  List<Object> get props => [event];

  @override
  String toString() => 'Post Updated {post: $event}';
}

class EventDelete extends EventEvent {
  final String event;

  const EventDelete(this.event);

  @override
  List<Object> get props => [event];

  @override
  toString() => 'post Deleted {post: $event}';
}
class ShowRemainig extends EventEvent {
  final String id;
  const ShowRemainig(this.id);

  @override
  @override
  List<Object> get props => [];
}
