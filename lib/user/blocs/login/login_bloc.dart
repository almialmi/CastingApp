// import 'package:appp/lib.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final AuthenticationBloc _authenticationBloc;
//   final UserRepository _userRepository;

//   LoginBloc(AuthenticationBloc authenticationBloc,
//       UserRepository authentication_userRepository)
//       : assert(authenticationBloc != null),
//         assert(authentication_userRepository != null),
//         _authenticationBloc = authenticationBloc,
//         _userRepository = authentication_userRepository,
//         super(LoginInitial());

//   @override
//   Stream<LoginState> mapEventToState(LoginEvent event) async* {
//     if (event is LoginInWithEmailButtonPressed) {
//       yield* _mapLoginWithEmailToState(event);
//     }
//   }

//   Stream<LoginState> _mapLoginWithEmailToState(
//       LoginInWithEmailButtonPressed event) async* {
//     yield LoginLoading();
//     try {
//       final user = await _userRepository.signInWithEmailAndPassword(event.user);

//       if (user != null) {
//         print('userEmail');
//         print(user.email);
//         _authenticationBloc.add(UserLoggedIn(user: user));
//         yield LoginSuccess();
//         yield LoginInitial();
//       } else {
//         yield LoginFailure(error: 'Something went wrong');
//       }
//     } on Exception catch (e) {
//       print(e);
//       yield LoginFailure(error: "");
//     } catch (err) {
//       yield LoginFailure(
//           error: Error.safeToString(err) ?? 'An unknown error occured');
//     }
//   }
// }

import 'package:appp/lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChange) {
      yield* _mapLoginEmailChangeToState(event.email);
    } else if (event is LoginPasswordChanged) {
      yield* _mapLoginPasswordChangeToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapLoginEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<LoginState> _mapLoginPasswordChangeToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {String email, String password}) async* {
    yield LoginState.loading();
    try {
      final message =
          await _userRepository.signInWithEmailAndPassword(email, password);
      if (message == "Login Successfully!!") {
        yield LoginState.success();
      } else if (message == "Email is not found") {
        yield LoginState.emailnotfoud();
      } else if (message ==
          "You have exceeded the maximum number of login attempts.You may attempt to log in again after 2 hours.") {
        yield LoginState.accountlocked();
      } else if (message == "Your Account is deactivated") {
        yield LoginState.accountdeacivate();
      } else if (message == "Incorrect password") {
        yield LoginState.incorectpassword();
      }

      print("ere love");
    } catch (e, a) {
      print("fucking login responce $e");
      yield LoginState.failure();
    }
  }
}
