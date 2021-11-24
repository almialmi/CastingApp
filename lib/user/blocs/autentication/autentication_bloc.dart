import 'package:appp/lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({UserRepository userRepository})
      : userRepository = userRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState();
    }

    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    String roleuser;
    SharedPrefHandler.getrolevalue().then((role) {
      roleuser = role;
    });
    yield AuthenticationLoading();
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final currentUser = await userRepository.isSignedIn();

      if (MyID != "" && MyID != null) {
        yield AuthenticationAuthenticated(
            await userRepository.getLoggedInUser());
      } else {
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(
          message: Error.safeToString(e) ?? 'An unknown error occurred');
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState() async* {
    yield AuthenticationAuthenticated(await userRepository.getLoggedInUser());
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState() async* {
    await userRepository.signOut();
    yield AuthenticationNotAuthenticated();
  }
}
