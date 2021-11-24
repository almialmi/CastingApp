import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final List<int> image;
  const ProfileImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ClipRRect(
      child: Image.memory(
        Uint8List.fromList(image),
        height: 60,
        width: 60,
      ),
      borderRadius: BorderRadius.circular(100.0),
    ));
    // CircleAvatar(
    //   radius: 30,
    //   child: ClipOval(
    //     child: Image.memory(Uint8List.fromList(image)),
    //   ),

    // ),
    // decoration: new BoxDecoration(
    //   shape: BoxShape.circle,
    //   border: new Border.all(
    //     color: Colors.white,
    //     width: 1.0,
    //   ),
    // ),
    // );
  }
}
