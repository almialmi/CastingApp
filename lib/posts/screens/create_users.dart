import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

class CreateUsers extends StatefulWidget {
  final bool edit;
  final PostElement post;
  
  const CreateUsers({
    Key key,
    this.edit,
    this.post,
   
  }) : super(key: key);
  @override
  _CreateUsersState createState() => _CreateUsersState();
}

class _CreateUsersState extends State<CreateUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar.buildAppbar(
            context, widget.edit == true ? "Update User" : "Create User"),
        body: CreateIdeaForm(edit: widget.edit, post: widget.post));
  }
}
