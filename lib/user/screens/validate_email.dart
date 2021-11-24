import 'dart:convert';
import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ValidateEmail extends StatefulWidget {
  final UserRepository _userRepository;

  ValidateEmail({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);
//  ValidateEmail({Key key, this.userRepository}) : super(key: key);

  bool _passwordVisible;

  @override
  _ValidateEmailState createState() => _ValidateEmailState();
}

class _ValidateEmailState extends State<ValidateEmail> {
  @override
  void initState() {
    super.initState();
    widget._passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _codeController = TextEditingController();
    // ignore: close_sinks
    final showBloc = BlocProvider.of<UserBloc>(context);
    showBloc.add(Verifyemail("$_codeController"));
    return Scaffold(
      body:
          //Center(
          //child:
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
              DefaultButton(
                text: "Next->",
                press: () async {
                  print("zare gid new" + _codeController.text);
                  //verifyemail(_codeController.text);
                  final user = await verifyemail(_codeController.text);
                  Map<String, dynamic> message = jsonDecode(user);
                  final emailmessage = message['message'];
                  if (emailmessage == "User Account activate") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  userRepository: widget._userRepository,
                                )));
                  } else if (emailmessage == "User Not found.") {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 20),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('User not found...'),
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            ],
                          ),
                          backgroundColor: Colors.white70,
                        ),
                      );
                  }

                  print(emailmessage);
                  print('Howdy, ${message['message']}!');

                  print("this is json file $user");
                  
                },
              )
            ],
          ),
        ),
      ),
     
    );
  }

  Future<String> verifyemail(String code) async {
    var url = Uri.parse('$baseURL/api/verfiyEmail/$code');
    print(url);
    final response = await http.get(
      url,
      headers: (<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }),
    );
    print(response.body);
    return response.body;
  }
}
