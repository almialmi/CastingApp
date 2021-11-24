import 'package:flutter/material.dart';

class CircularIndicat extends StatelessWidget {
  const CircularIndicat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      child: CircularProgressIndicator(),
      width: 50,
      height: 50,
    ));
  }
}
