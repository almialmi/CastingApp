// import 'package:appp/lib.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class RegistorBloc extends Bloc<RegistorEvent, RegistorState> {
//   // final UserRepository userRepository;
//   // final AuthenticationBloc authenticationBloc;
//   // final AuthenticationRepository authenticationRepository;

//   final AuthenticationBloc _authenticationBloc;
//   final UserRepository userRepository;

//   RegistorBloc(
//       {AuthenticationBloc authenticationBloc, UserRepository userRepository})
//       : assert(userRepository != null),
//         _authenticationBloc = authenticationBloc,
//         userRepository = userRepository,
//         super(RegistorInitial());

//   @override
//   Stream<RegistorState> mapEventToState(RegistorEvent event) async* {
//     if (event is RegistrWithSignUpButtonPressed) {
//       yield* _mapRegistorWithEmailToState(event);
//     }
//   }

//   Stream<RegistorState> _mapRegistorWithEmailToState(
//       RegistrWithSignUpButtonPressed event) async* {
//     yield ReggistorLoading();
//     try {
//       print('user is not working bzw');
//       await userRepository.registor(event.user);

//       // _authenticationBloc.add(UserLoggedIn(user: user));
//       yield RegistorSuccess();
//       yield RegistorInitial();
//     } on Exception catch (e) {
//       print(e);
//       yield RegistorFailure(error: "");
//     } catch (err) {
//       yield RegistorFailure(
//           error: Error.safeToString(err) ?? 'An unknown error occured');
//     }
//   }
// }

// class RegistorLoading {}

import 'package:appp/lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangeToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangeToState(event.password);
    } else if (event is RegisterUserNameChanged) {
      yield* _mapRegisterUserNameChangeToState(event.userName);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(
          email: event.email,
          password: event.password,
          username: event.username);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<RegisterState> _mapRegisterUserNameChangeToState(
      String userName) async* {
    yield state.update(isUserNameValid: Validators.isValidEmail(userName));
  }

  Stream<RegisterState> _mapRegisterPasswordChangeToState(
      String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
      {String email, String password, username}) async* {
    yield RegisterState.loading();
    try {
      final message = await _userRepository.registor(email, password, username);
      print(message);
      if (message == "User is registered successfully!") {
        yield RegisterState.success();
      } else if (message == "Please provide a valid email address.") {
        yield RegisterState.emailexsit();
      }
    } catch (error) {
      print(error);
      yield RegisterState.failure();
    }
  }
}
