import 'dart:io';

import 'package:appp/lib.dart';
import 'package:appp/posts/screens/user_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatefulWidget {
  final Userr user;
  const MyProfile({Key key, this.user}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File imagefile;
  Future<void> _cropImage(imageFile) async {
    if (imageFile == null) {
      return;
    }
    File cropped = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        ratioX: 4.0,
        ratioY: 3.0,
        // maxWidth: 512,
        // maxHeight: 512,
        toolbarColor: Colors.black87,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It');

    setState(() {
      this.imagefile = cropped ?? imageFile;
    });

    final UserEvent event = ProfilePicUpdate(imagefile);

    BlocProvider.of<UserBloc>(context).add(event);
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    if (selected == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No image is selected"),
      ));
      return;
    }

    setState(() {
      //this.imagefile.add(selected);
      //this.imageCount = this.imageFile.length;
      _cropImage(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        //appBar: MyAppBar.buildAppbar(context, " "),
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  if (widget.user.profilePic != null)
                    Container(
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: imagefile == null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        "${baseURL}/api/${widget.user.profilePic}",
                                    // width: 70,
                                    //height: 70,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  )
                                : Image.file(File(imagefile.path)))),
                  if (widget.user.profilePic == null)
                    Container(
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: imagefile == null
                                ? Image.asset("assets/images/castprofile.png")
                                : Image.file(File(imagefile.path)))),
                ],
              ),
            ),
            //Padding(
            // padding: const EdgeInsets.all(20.0),
            //child:
            Positioned.fill(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      color: Colors.black,
                      iconSize: 30,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      })),
              //),
            ),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      color: Colors.black,
                      iconSize: 50,
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return bottomsheet();
                            });
                      })),
            ),
            // Padding(
            // padding: const EdgeInsets.all(20.0),
            //child:
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomLeft,
              child: DayNightSwitch(),
            )),
            //),
          ]),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(children: [
              makeemail(Icons.email, widget.user.email, "tap to change email"),
              _makediscription(
                  Icons.person, widget.user.userName, "tap to change userName"),
            ]),
          )
        ],
      ),
    ));
  }

  makeemail(IconData icon, String text, String text2) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Email(user: text)));
      },
      child: Card(
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Email(user: text)));
                },
                icon: Icon(
                  icon,
                  size: 40.0,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              SizedBox(width: 24.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  _makediscription(IconData icon, String text, String text2) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserName(user: text)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {}
                //
                ,
                icon: Icon(
                  icon,
                  size: 40.0,
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
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Text(
            "choose profile picture",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text("Camera")),
              FlatButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.photo),
                  label: Text("Gallery"))
            ],
          )
        ],
      ),
    );
  }
}
