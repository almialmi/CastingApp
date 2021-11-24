
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileImagee extends StatelessWidget {
  final image;
  const ProfileImagee({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ClipRRect(
            child: CachedNetworkImage(
              imageUrl: image,
              width: 70,
              height: 70,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
            borderRadius: BorderRadius.circular(100.0)));
    //   Image.network(
    //     image,
    //     width: 70,
    //     height: 70,
    //   ),
    //   borderRadius: BorderRadius.circular(100.0),
    // ));

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
