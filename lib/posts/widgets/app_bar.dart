import 'package:flutter/material.dart';

class MyAppBar {
  static AppBar buildAppbar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.white70,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
