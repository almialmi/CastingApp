import 'dart:convert';
import 'package:appp/lib.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class NewPassword extends StatefulWidget {
  final UserRepository _userRepository;
  final String token;

  NewPassword({Key key, UserRepository userRepository, this.token})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _codeController = TextEditingController();

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
                    border: OutlineInputBorder(),
                    labelText: 'new password',
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please insert new password';
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

                      final user = await newPasswordReset(
                          _codeController.text, widget.token);
                      print("this is also fuck $user");

                      if (user == "Password reset successfully") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                      userRepository: widget._userRepository,
                                    )));
                      } else if (user == "Token has expired or not found") {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('token has expired'),
                                  Icon(Icons.info)
                                ],
                              ),
                              backgroundColor: Theme.of(context).shadowColor,
                            ),
                          );
                      } else if (user == "User does not exist") {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('user does not exit'),
                                  Icon(Icons.info)
                                ],
                              ),
                              backgroundColor: Theme.of(context).shadowColor,
                            ),
                          );
                      } else if (user == "Password can not reset.") {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('password can not be reset'),
                                  Icon(Icons.info)
                                ],
                              ),
                              backgroundColor: Theme.of(context).shadowColor,
                            ),
                          );
                      } else if (user ==
                          "please enter strong by the combination of capital letter,special character and small letter!!") {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('please insert strong password'),
                                  Icon(Icons.info)
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

  Future<String> newPasswordReset(String newpassword, String resettoken) async {
    print("this is rest token $resettoken");
    var url = Uri.parse('$baseURL/api/newPassword');
    print(url);
    final response = await http.post(
      url,
      headers: (<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }),
      body: jsonEncode(<String, dynamic>{
        'resettoken': resettoken,
        'newPassword': newpassword
      }),
    );
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      print("fuck is ${response.body}");
      return response.body;
    }
    print("new password $result");
    return ("${result['message']}");
  }
}
