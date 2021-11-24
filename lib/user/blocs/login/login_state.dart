// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// abstract class LoginState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class LoginInitial extends LoginState {}

// class LoginLoading extends LoginState {}

// class LoginSuccess extends LoginState {}

// class LoginFailure extends LoginState {
//   final String error;

//   LoginFailure({@required this.error});

//   @override
//   List<Object> get props => [error];
// }

class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool emailnotfound;
  final bool accountlocked;
  final bool incorectpassword;
  final bool accountdeactivate;

  bool get isFormValid => isEmailValid && isPasswordValid;

  LoginState({
    this.incorectpassword,
    this.accountlocked,
    this.emailnotfound,
    this.isEmailValid,
    this.isPasswordValid,
    this.isSubmitting,
    this.isSuccess,
    this.isFailure,
    this.accountdeactivate,
  });

  factory LoginState.initial() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        accountlocked: false,
        emailnotfound: false,
        incorectpassword: false,
        accountdeactivate: false);
  }

  factory LoginState.loading() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        accountlocked: false,
        emailnotfound: false,
        incorectpassword: false,
        accountdeactivate: false);
  }
  factory LoginState.failure() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        accountlocked: true,
        emailnotfound: true,
        incorectpassword: false,
        accountdeactivate: false);
  }

  factory LoginState.incorectpassword() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        accountlocked: false,
        emailnotfound: false,
        incorectpassword: true,
        accountdeactivate: false);
  }
   factory LoginState.accountdeacivate() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        accountlocked: false,
        emailnotfound: false,
        incorectpassword: false,
        accountdeactivate: true);
  }

  factory LoginState.emailnotfoud() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        accountlocked: false,
        emailnotfound: true,
        incorectpassword: false,
        accountdeactivate: false);
  }

  factory LoginState.accountlocked() {
    return LoginState(
        emailnotfound: false,
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        accountlocked: true,
        incorectpassword: false,
        accountdeactivate: false);
  }

  factory LoginState.success() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        accountlocked: false,
        emailnotfound: false,
        incorectpassword: false,
        accountdeactivate: false);
  }

  LoginState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
        isEmailValid: isEmailValid,
        isPasswordValid: isPasswordValid,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        emailnotfound: false,
        accountlocked: false,
        );
  }

  LoginState copyWith(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure,
      bool emailnotfound,
      bool accountlocked,
      bool incorectpassword,
      bool accountdeactivate}) {
    return LoginState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        emailnotfound: emailnotfound ?? this.emailnotfound,
        accountlocked: accountlocked ?? this.accountlocked,
        incorectpassword: incorectpassword ?? this.incorectpassword,
        accountdeactivate:  accountdeactivate ?? this.accountdeactivate
        );
  }
}

class IncorectPassword extends LoginState {
  final String message;

  IncorectPassword([this.message]);

  @override
  List<Object> get props => [message];
}
