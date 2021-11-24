import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserName extends StatelessWidget {
  final String user;
  UserName({Key key, this.user}) : super(key: key);
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
              maxLength: 10,
              initialValue: user,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                //hintText: 'discreption about the user?',
                labelText: 'username *',
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Please insert username';
                }
                return null;
              },
              onChanged: (val) {
                this._user['userName'] = val;
              }),
          SizedBox(
            height: 20.0,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "you can choose a user name on this app so when ever you take some action your username will be visibile in others account \n\n a valid user name can be any thing which can have less than 10 letters .    ",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _saveusername(BuildContext context) {
    final UserEvent event = UserUpdate(
      Userr(
        userName: this._user['userName'],
      ),
    );

    BlocProvider.of<UserBloc>(context).add(event);
  }
}
