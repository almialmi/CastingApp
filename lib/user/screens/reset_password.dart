import 'dart:convert';
import 'package:appp/lib.dart';
import 'package:appp/user/screens/validate_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  final UserRepository _userRepository;

  ResetPassword({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _codeController = TextEditingController();
    // ignore: close_sinks
    // final showBloc = BlocProvider.of<UserBloc>(context);
    // showBloc.add(Verifyemail("$_codeController"));
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    //border: OutlineInputBorder(),
                    labelText: 'insert email to reset',
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please insert email';
                    }
                    return null;
                  },
                  // onChanged: (value) => this._cat['name'] = value
                  //  double.parse(value),
                ),
                SizedBox(
                  height: 100.0,
                ),
                Builder(
                  builder: (context) => DefaultButton(
                    text: "Next->",
                    press: () async {
                      print("zare gid new" + _codeController.text);

                      final user = await resetPassword(_codeController.text);

                      if (user ==
                          "Reset password code send.Check your email.") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetCode(
                                      userRepository: widget._userRepository,
                                    )));
                      } else if (user == "Email does not exist") {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('email does not exist...'),
                                ],
                              ),
                              backgroundColor: Theme.of(context).shadowColor,
                            ),
                          );
                      } else if (user == "connection time out") {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('please try again!'),
                                ],
                              ),
                              backgroundColor: Theme.of(context).shadowColor,
                            ),
                          );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        // );

        // }
      ),
    );
  }

  // Future<String> verifyemail(String code) async {
  //   var url = Uri.parse('$baseURL/api/verfiyEmail/$code');
  //   print(url);
  //   final response = await http.get(
  //     url,
  //     headers: (<String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     }),
  //   );
  //   print(response.body);
  //   return response.body;
  // }

  Future<String> resetPassword(String email) async {
    var url = Uri.parse('$baseURL/api/resetPassword');
    print(url);
    final response = await http.post(
      url,
      headers: (<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }),
      body: jsonEncode(<String, dynamic>{
        'email': email,
      }),
    );
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {}
    print(result);
    return ("${result['message']}");
  }
}
