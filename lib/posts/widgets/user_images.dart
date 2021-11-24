
import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

import '../../size_config.dart';

class IssueImages extends StatefulWidget {
  const IssueImages({
    Key key,
    this.post,
  }) : super(key: key);

  final PostElement post;

  @override
  _IssueImagesState createState() => _IssueImagesState();
}

class _IssueImagesState extends State<IssueImages> {
  String selectedImage;
  List<dynamic> images = [];

  @override
  Widget build(BuildContext context) {
    return _images();
  }

  Column _images() {
    List<int> url;
    return Column(
      children: [
        SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSmallProductPreview("${baseURL}/api/${widget.post.photo1}"),
            buildSmallProductPreview("${baseURL}/api/${widget.post.photo2}"),
            buildSmallProductPreview("${baseURL}/api/${widget.post.photo3}")
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(url) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = url;
        });
      },
      child: AnimatedContainer(
          duration: defaultDuration,
          margin: EdgeInsets.only(right: 15),
          padding: EdgeInsets.all(8),
          height: getProportionateScreenWidth(48),
          width: getProportionateScreenWidth(48),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)
              //kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
              ),
          child: ProfileImagee(
            image: url,
          )
          // Image.memory(Uint8List.fromList(url)),
          ),
    );
  }
}
