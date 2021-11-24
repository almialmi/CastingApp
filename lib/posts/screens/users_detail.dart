import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailUsers extends StatelessWidget {
  final PostElement post;

  const DetailUsers({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: MyAppBar.buildAppbar(context, " "),
        body: SingleChildScrollView(
      child: Column(
        children: [
          StackContainer(post: post),
          IssueImages(
            post: post,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(children: [
              _makecards(Icons.call, post.mobile, "phone number", context),
              makeemail(Icons.person, post.age.toString(), "age", context),
              _makediscription(
                  Icons.description, post.video, "vedio link", context),
            ]),
          )
        ],
      ),
    ));
  }

  makeemail(IconData icon, String text, String text2, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                launch("Age:$text");
              }
              //
              ,
              icon: Icon(
                icon,
                size: 30.0,
                color: Theme.of(context).shadowColor,
              ),
            ),
            SizedBox(width: 24.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  text2,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _makecards(IconData icon, String text, String text2, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 21.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                launch("tel://$text");
              }
              //
              ,
              icon: Icon(
                icon,
                size: 30.0,
                color: Theme.of(context).shadowColor,
              ),
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  text2,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _makediscription(
      IconData icon, String text, String text2, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 21.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                launch("https://www.youtube.com/watch?v=$text");
              }
              //
              ,
              icon: Icon(
                icon,
                size: 30.0,
                color: Theme.of(context).shadowColor,
              ),
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "https://www.youtube.com/watch?v=$text",
                  style: TextStyle(
                    fontSize: 9.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  text2,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
