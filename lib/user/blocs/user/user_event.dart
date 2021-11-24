
import 'dart:io';

import 'package:appp/lib.dart';
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserLoad extends UserEvent {
  const UserLoad();

  @override
  @override
  List<Object> get props => [];
}

class UserUpdate extends UserEvent {
  //final File image;
  final Userr user;

  const UserUpdate(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Request Updated {post: $user}';
}
class ProfilePicUpdate extends UserEvent {
  //final File image;
  final File image;

  const ProfilePicUpdate(this.image);

  @override
  List<Object> get props => [image];

  @override
  String toString() => 'Request Updated {post: $image}';
}
class Verifyemail extends UserEvent {
  final String code;
  const Verifyemail(this.code);

  @override
  @override
  List<Object> get props => [];
}

