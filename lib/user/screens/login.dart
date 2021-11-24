// import 'package:appp/lib.dart';
// import 'package:appp/posts/screens/home.dart';
// import 'package:appp/user/user.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // class AuthForm extends StatelessWidget {
// //   final BuildContext context;

// //   const AuthForm({Key key, this.context}) : super(key: key);
// //   @override
// //   Widget build(BuildContext context) {
// //     final authService = RepositoryProvider.of<UserRepository>(context);
// //     // ignore: close_sinks
// //     final authBloc = BlocProvider.of<AuthenticationBloc>(context);
// //     return Container(
// //         alignment: Alignment.center,
// //         child: BlocProvider<LoginBloc>(
// //           create: (context) => LoginBloc(authBloc, authService),
// //           child: LoginScreen(),
// //         ));
// //   }
// // }

// class LoginScreen extends StatefulWidget {
//   final UserRepository _userRepository;

//   const LoginScreen({Key key, UserRepository userRepository})
//       : _userRepository = userRepository,
//         super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String email = "";
//   String password = "";

//   GlobalKey<FormState> _form = GlobalKey<FormState>();
//   bool _isSelected = false;

//   void _radio() {
//     setState(() {
//       _isSelected = !_isSelected;
//     });
//   }

//   bool _validate() {
//     return _form.currentState.validate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ignore: close_sinks
//     // final catbloc = BlocProvider.of<CatBloc>(context);
//     // catbloc.add(CategoryLoad());

//     // ignore: close_sinks
//     // final eventbloc = BlocProvider.of<EventBloc>(context);
//     // eventbloc.add(EventLoad("false"));
//     SizeConfig().init(context);
//     getProportionateScreenHeight(1334);
//     getProportionateScreenWidth(750);
//     // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
//     // ScreenUtil.instance =
//     //  ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Container(
//         height: double.infinity,
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xff6a515e), Color(0xff6a515e)],
//         )),
//         child: SingleChildScrollView(
//           child: Stack(
//             children: <Widget>[
//               CurvedWidget(
//                 child: Container(
//                   padding: const EdgeInsets.only(top: 100, left: 50),
//                   width: double.infinity,
//                   height: 300,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [Colors.white, Colors.white.withOpacity(0.4)],
//                     ),
//                   ),
//                   child: Text(
//                     'Login',
//                     style: TextStyle(
//                       fontSize: 40,
//                       color: Color(0xff6a515e),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                   margin: const EdgeInsets.only(top: 230),
//                   child: BlocListener<LoginBloc, LoginState>(
//                     listener: (context, state) {
//                       if (state is LoginFailure) {
//                         Scaffold.of(context)
//                           ..removeCurrentSnackBar()
//                           ..showSnackBar(
//                             SnackBar(
//                               content: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Text('Login Failure'),
//                                   Icon(Icons.error),
//                                 ],
//                               ),
//                               backgroundColor: Color(0xff6a515e),
//                             ),
//                           );
//                       }

//                       if (state is LoginLoading) {
//                         Scaffold.of(context)
//                           ..removeCurrentSnackBar()
//                           ..showSnackBar(
//                             SnackBar(
//                               content: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Text('Logging In...'),
//                                   CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   )
//                                 ],
//                               ),
//                               backgroundColor: Color(0xff6a515e),
//                             ),
//                           );
//                       }

//                       if (state is LoginSuccess) {
//                         // ignore: close_sinks

//                         BlocProvider.of<AuthenticationBloc>(context).add(
//                           AppLoaded(),
//                         );
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => HomeScreenn(),
//                           ),
//                         );
//                         //ignore: close_sinks

//                         //return HomeScreenn();
//                       }
//                     },
//                     child: BlocBuilder<LoginBloc, LoginState>(
//                       builder: (context, state) {
//                         return Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Form(
//                             key: _formKey,
//                             child: Column(
//                               children: <Widget>[
//                                 TextFormField(
//                                   decoration: InputDecoration(
//                                       hintText: "email",
//                                       hintStyle: TextStyle(
//                                           color: Colors.grey, fontSize: 12.0)),
//                                   onChanged: (value) {
//                                     email = value;
//                                   },
//                                   validator: (value) {
//                                     if (value.isEmpty) {
//                                       return 'Please your firstName';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 TextFormField(
//                                   decoration: InputDecoration(
//                                       hintText: "password",
//                                       hintStyle: TextStyle(
//                                           color: Colors.grey, fontSize: 12.0)),
//                                   onChanged: (value) {
//                                     password = value;
//                                   },
//                                   validator: (value) {
//                                     if (value.isEmpty) {
//                                       return 'Please your firstName';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 GradientButton(
//                                   width: 150,
//                                   height: 45,
//                                   onPressed: () {
//                                     if (_formKey.currentState.validate()) {
//                                       BlocProvider.of<LoginBloc>(context).add(
//                                           LoginInWithEmailButtonPressed(
//                                               user: Userr.login(
//                                                   email: email,
//                                                   password: password)));
//                                     }
//                                   },
//                                   text: Text(
//                                     'LogIn',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   icon: Icon(
//                                     Icons.check,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 GradientButton(
//                                   width: 150,
//                                   height: 45,
//                                   onPressed: () {
//                                     Navigator.push(context,
//                                         MaterialPageRoute(builder: (_) {
//                                       return RegistorScreen();
//                                     }));
//                                   },
//                                   text: Text(
//                                     'Register',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   icon: Icon(
//                                     Icons.arrow_forward,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget radioButton(bool isSelected) => Container(
//         width: 16.0,
//         height: 16.0,
//         padding: EdgeInsets.all(2.0),
//         decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(width: 2.0, color: Colors.black)),
//         child: isSelected
//             ? Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 decoration:
//                     BoxDecoration(shape: BoxShape.circle, color: Colors.black),
//               )
//             : Container(),
//       );

//   Widget horizontalLine() => Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: Container(
//           //  width: ScreenUtil.getInstance().setWidth(120),
//           height: 1.0,
//           color: Colors.black26.withOpacity(.2),
//         ),
//       );
// }
