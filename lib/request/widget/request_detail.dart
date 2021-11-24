import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

class RequestDetail extends StatelessWidget {
  final RequestElement request;

  const RequestDetail({Key key, this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.buildAppbar(context, 'Requested User detail'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // StackContainer(),
            CardItem(request: request)
            
          ],
        ),
      ),
    );
  }
}
