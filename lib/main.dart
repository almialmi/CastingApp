import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:appp/theme_bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefHandler.getidvalue().then((value) => MyID = value);
  SharedPrefHandler.getrolevalue().then((value) => ROLE = value);
  Bloc.observer = SimpleBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  final UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
    create: (context) => AuthenticationBloc(
      userRepository: userRepository,
    )..add(AppLoaded()),
    child: MyApp(
      userRepository: userRepository,
    ),
  ));
}

class MyApp extends StatelessWidget {
  MaterialColor kPrimaryColor = const MaterialColor(
    0xFF59253A,
    const <int, Color>{
      50: const Color(0xFF59253A),
      100: const Color(0xFF59253A),
      200: const Color(0xFF59253A),
      300: const Color(0xFF59253A),
      400: const Color(0xFF59253A),
      500: const Color(0xFF59253A),
      600: const Color(0xFF59253A),
      700: const Color(0xFF59253A),
      800: const Color(0xFF59253A),
      900: const Color(0xFF59253A),
    },
  );
  final UserRepository _userRepository;
  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              lazy: false,
              create: (context) => CatBloc(catrepository: CatRepo())),

          BlocProvider(
              lazy: false,
              create: (context) => EventBloc(eventrepository: EventRepo())),
          BlocProvider(
              lazy: false,
              create: (context) => ShowBloc(eventrepository: EventRepo())),

          BlocProvider(
              lazy: false,
              create: (context) => PostBloc(postrepository: PostRepo())),

          BlocProvider(
              lazy: false,
              create: (context) => MaleBloc(postrepository: PostRepo())),

          BlocProvider(
              lazy: false,
              create: (context) => LikeDislikeBloc(postrepository: PostRepo())),

          BlocProvider(
              lazy: false,
              create: (context) =>
                  LikeDislikeCompBloc(comprepository: ComputationRepo())),
          // BlocProvider(
          //     lazy: false,
          //     create: (context) => AllUserBloc(postrepository: PostRepo())),
          BlocProvider(
              lazy: false,
              create: (context) =>
                  RequestBloc(requestrepository: RequestRepo())),

          BlocProvider(
              lazy: false,
              create: (context) => CompBloc(comprepository: ComputationRepo())),

          BlocProvider(
              lazy: false,
              create: (context) => UserBloc(userrepository: UserRepository())),
          BlocProvider(
              lazy: false,
              create: (context) => LoginBloc(userRepository: UserRepository())),

          BlocProvider<ThemeBloc>(
              create: (_) => ThemeBloc()..add(ThemeLoadStarted())),

          BlocProvider(
              lazy: false,
              create: (context) =>
                  AdvertBloc(advertrepository: AdvertRepo())), // FriendsBloc
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themestate) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              themeMode: themestate.themeMode,
              theme: ThemeData(
                shadowColor: const Color(0xFF59253A),
                disabledColor: const Color(0xFF201e1e),
                indicatorColor: const Color(0xFF59253A),
                primaryColor: const Color(0xFF59253A),

                // accentColor: Colors.cyan[600],
                accentColor: Color(0xFF59253A),
                primarySwatch: kPrimaryColor,
              ),
              darkTheme: ThemeData(
                shadowColor: Colors.white70,
                disabledColor: Color(0xFF1e1d1d),
                indicatorColor: const Color(0xFF1e1d1d),
                accentColor: const Color(0xFF59253A),
                primarySwatch: kPrimaryColor,
                //brightness: Brightness.light,
                brightness: Brightness.dark,
                primaryColor: Colors.black12,
              ),
              home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationNotAuthenticated) {
                    return LoginScreen(
                      userRepository: _userRepository,
                    );
                  } else if (state is AuthenticationAuthenticated) {
                    return HomeScreenn(userRepository: _userRepository);
                  }

                  return Text("");
                },
              ),
            );
          },
        ));
  }
}
