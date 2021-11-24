import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Email extends StatelessWidget {
  final String user;
  Email({Key key, this.user}) : super(key: key);
  final Map<String, dynamic> _user = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _saveusername(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreenn()));
              })
        ],
      ),
      body: Column(
        children: [
          TextFormField(
              initialValue: user,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                //hintText: 'discreption about the user?',
                labelText: 'email *',
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Please insert email';
                }
                return null;
              },
              onChanged: (val) {
                this._user['email'] = val;
              }),
          SizedBox(
            height: 20.0,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
                "you can use any valid email here but mind this will cause you change the login credentials that you have entered. \n\n a valid email has @ symbol plus it should exit somewhere in the cloud.    ",
                style: TextStyle(
                  color: Colors.grey,
                )),
          ),
        ],
      ),
    );
  }

  void _saveusername(BuildContext context) {
    final UserEvent event = UserUpdate(
      Userr(
        email: this._user['email'],
      ),
    );

    BlocProvider.of<UserBloc>(context).add(event);
  }
}
