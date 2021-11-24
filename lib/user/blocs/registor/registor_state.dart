// // import 'package:equatable/equatable.dart';
// // import 'package:flutter/material.dart';

// // abstract class RegistorState extends Equatable {
// //   @override
// //   List<Object> get props => [];
// // }

// // class RegistorInitial extends RegistorState {}

// // class ReggistorLoading extends RegistorState {}

// // class RegistorSuccess extends RegistorState {}

// // class RegistorFailure extends RegistorState {
// //   final String error;

// //   RegistorFailure({@required this.error});

// //   @override
// //   List<Object> get props => [error];
// // }

// class RegisterState {
//   final bool isEmailValid;
//   final bool isPasswordValid;
//   final bool isSubmitting;
//   final bool isSuccess;
//   final bool isFailure;

//   bool get isFormValid => isEmailValid && isPasswordValid;

//   RegisterState(
//       {this.isEmailValid,
//         this.isPasswordValid,
//         this.isSubmitting,
//         this.isSuccess,
//         this.isFailure});

//   factory RegisterState.initial() {
//     return RegisterState(
//       isEmailValid: true,
//       isPasswordValid: true,
//       isSubmitting: false,
//       isSuccess: false,
//       isFailure: false,
//     );
//   }

//   factory RegisterState.loading() {
//     return RegisterState(
//       isEmailValid: true,
//       isPasswordValid: true,
//       isSubmitting: true,
//       isSuccess: false,
//       isFailure: false,
//     );
//   }

//   factory RegisterState.failure() {
//     return RegisterState(
//       isEmailValid: true,
//       isPasswordValid: true,
//       isSubmitting: false,
//       isSuccess: false,
//       isFailure: true,
//     );
//   }

//   factory RegisterState.success() {
//     return RegisterState(
//       isEmailValid: true,
//       isPasswordValid: true,
//       isSubmitting: false,
//       isSuccess: true,
//       isFailure: false,
//     );
//   }

//   RegisterState update({
//     bool isEmailValid,
//     bool isPasswordValid,
//   }) {
//     return copyWith(
//       isEmailValid: isEmailValid,
//       isPasswordValid: isPasswordValid,
//       isSubmitting: false,
//       isSuccess: false,
//       isFailure: false,
//     );
//   }

//   RegisterState copyWith({
//     bool isEmailValid,
//     bool isPasswordValid,
//     bool isSubmitting,
//     bool isSuccess,
//     bool isFailure,
//   }) {
//     return RegisterState(
//       isEmailValid: isEmailValid ?? this.isEmailValid,
//       isPasswordValid: isPasswordValid ?? this.isPasswordValid,
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//       isSuccess: isSuccess ?? this.isSuccess,
//       isFailure: isFailure ?? this.isFailure,
//     );
//   }
// }

class RegisterState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isUsernamevalid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool validemail;

  bool get isFormValid => isEmailValid && isPasswordValid;

  RegisterState(
      {
        this.validemail,
        this.isUsernamevalid,
      this.isEmailValid,
      this.isPasswordValid,
      this.isSubmitting,
      this.isSuccess,
      this.isFailure});

  factory RegisterState.initial() {
    return RegisterState(
      isUsernamevalid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      validemail: false
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      validemail: false
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      validemail: false
    );
  }
  factory RegisterState.emailexsit() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      validemail: true,
      
    );
  }


  factory RegisterState.success() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      validemail: false
    );
  }

  RegisterState update(
      {bool isEmailValid, bool isPasswordValid, bool isUserNameValid}) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      validemail: false
    );
  }

  RegisterState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool validemail,
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      validemail: validemail ?? this.validemail
    );
  }
}
