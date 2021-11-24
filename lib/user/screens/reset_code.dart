import 'dart:convert';
import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ResetCode extends StatefulWidget {
  final UserRepository _userRepository;

  ResetCode({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);
//  ValidateEmail({Key key, this.userRepository}) : super(key: key);

  bool _passwordVisible;

  @override
  _ResetCodeState createState() => _ResetCodeState();
}

class _ResetCodeState extends State<ResetCode> {
  @override
  void initState() {
    super.initState();
    widget._passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _codeController = TextEditingController();
    // ignore: close_sinks
    // final showBloc = BlocProvider.of<UserBloc>(context);
    // showBloc.add(Verifyemail("$_codeController"));
    return Scaffold(
      body:
          //Center(
          Padding(
        padding: const EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                "please check your email and write the code below",
                style: TextStyle(
                    color: Theme.of(context).shadowColor, fontFamily: 'Oxygen'),
              )),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: _codeController,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: "code:",
                ),
                autovalidate: true,
                autocorrect: false,
              ),
              SizedBox(
                height: 100.0,
              ),
              Builder(
                builder: (context) => DefaultButton(
                  text: "Next->",
                  press: () async {
                    print("zare gid new" + _codeController.text);
                    //verifyemail(_codeController.text);
                    final emailmessage =
                        await verifytoken(_codeController.text);
                    //Map<String, dynamic> message = await jsonDecode(user);
                    // final emailmessage = message['message'];
                    if (emailmessage == "Token verified successfully.") {
                      print("the fuck");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewPassword(
                                    userRepository: widget._userRepository,
                                    token: _codeController.text,
                                  )));
                    } else if (emailmessage == "Invalid code") {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('invalid code'),
                                Icon(Icons.info)
                                // CircularProgressIndicator(
                                //   valueColor: AlwaysStoppedAnimation<Color>(
                                //       Colors.white),
                                // )
                              ],
                            ),
                            backgroundColor: Theme.of(context).shadowColor,
                          ),
                        );
                    }

                    // final messe = await jsonDecode(user);

                    // var myJson = {
                    //   "label": "This is a string",
                    //   "value": {
                    //     "address": "This is a string",
                    //     "country": "This is a string"
                    //   }
                    // };
                    // try {
                    //   var messs = await jsonDecode(myJson['label']);
                    //   print(messs);
                    //   if (messs == "User Not found.") {
                    //     print("user not found");
                    //     return Text("please try again");
                    //   } else if (messs == "User Account activate") {
                    //     print("user account activated");
                    //     LoginScreen();
                    //   }
                    // } on Exception catch (e) {
                    //   print(e); // Only catches an exception of type `Exception`.
                    // }

                    //String message = jsonDecode(user);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      // );

      // }
      // ),
    );
  }

  Future<String> verifytoken(String code) async {
    var url = Uri.parse('$baseURL/api/validateToken');
    print(url);
    final response = await http.post(
      url,
      headers: (<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }),
      body: jsonEncode(<String, dynamic>{
        'resettoken': code,
      }),
    );
    final result = jsonDecode(response.body) as Map<String, dynamic>;

    print(result);
    return ("${result['message']}");
  }
}
