import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  RegisterEmailChanged({this.email});

  @override
  List<Object> get props => [email];
}

class RegisterUserNameChanged extends RegisterEvent {
  final String userName;

  RegisterUserNameChanged({this.userName});

  @override
  List<Object> get props => [userName];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  RegisterPasswordChanged({this.password});

  @override
  List<Object> get props => [password];
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String username;

  RegisterSubmitted({this.username, this.email, this.password});

  @override
  List<Object> get props => [email, password];
}
