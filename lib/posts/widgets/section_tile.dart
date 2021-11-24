import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(
      {Key key, @required this.title, @required this.press, this.more})
      : super(key: key);

  final String title;
  final press;
  final String more;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Row(
            children: [
              Text(this.more, style: TextStyle(color: Colors.black45)),
              Icon(
                Icons.navigate_next,
                color: Color(0xFFBBBBBB),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
