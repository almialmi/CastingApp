// import 'package:appp/lib.dart';

// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// abstract class LoginEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class LoginInWithEmailButtonPressed extends LoginEvent {
//   final Userr user;

//   LoginInWithEmailButtonPressed({@required this.user});

//   @override
//   List<Object> get props => [user];
// }


import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEmailChange extends LoginEvent {
  final String email;

  LoginEmailChange({this.email});

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({this.password});

  @override
  List<Object> get props => [password];
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class LogedInUserLoad extends LoginEvent {
    LogedInUserLoad();

  @override
  @override
  List<Object> get props => [];
}
