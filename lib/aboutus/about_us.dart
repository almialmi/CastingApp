import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
 

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
            appBar: MyAppBar.buildAppbar(context, "About"),
            body: Body(),
          );
  }

  
  
}
