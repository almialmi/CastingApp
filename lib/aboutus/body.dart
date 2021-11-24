import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Spacer(),
              Container(
                  width: 120,
                  height: 120,
                  child: Image.asset("assets/images/logo-modified.png")),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "ዘ-አራዳ",
            style: TextStyle(fontSize: 36.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () => {launch("tel://+251912843875")}, // ,
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.phone, color: Colors.black54),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  "Phone    +251912843875",
                  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () => {
              launch("mailto:zerita77@gmail.com"),
            },
            child: Row(
              children: [
                Spacer(),
                Icon(
                  Icons.email,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  "zerita77@gmail.com",
                  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    ));
  }
}
