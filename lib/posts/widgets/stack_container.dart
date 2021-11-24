
import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

class StackContainer extends StatelessWidget {
  final PostElement post;
  const StackContainer({
    Key key,
    this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).indicatorColor,
                    Theme.of(context).disabledColor
                  ],
                ),

                // image: DecorationImage(

                //   image: NetworkImage("https://picsum.photos/200" ),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    child: CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                          child: Image.network("${baseURL}/api/${post.photo1}")
                          //Uint8List.fromList((post.photo1.data.data))),
                          ),

                      // child: Image.memory(
                      //     Uint8List.fromList((post.photo1.data.data)))),

                      //radius: 60.0,
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Theme.of(context).indicatorColor,
                        width: 4.0,
                      ),
                    )),
                SizedBox(height: 4.0),
                Text(
                  "${post.firstName + " " + post.lastName}",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(
                //   "Developer",
                //   style: TextStyle(
                //     fontSize: 12.0,
                //     color: Colors.grey[700],
                //   ),
                // ),
              ],
            ),
          ),
          TopBar(),
        ],
      ),
    );
  }
}
