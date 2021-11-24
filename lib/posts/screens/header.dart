import 'dart:io';
import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Header extends StatefulWidget {
  final String email;
  final File imagefile;
  const Header({Key key, this.imagefile, this.email}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool isDarkModeEnabled = true;
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
      _cropImage(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserOperationFailure) {
          return DrawerHeader(
            padding: EdgeInsets.all(0.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).indicatorColor,
                    Theme.of(context).disabledColor
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.white70,
                        child: (widget.email != null && widget.email.length > 0)
                            ? Text(
                                widget.email[0].toUpperCase(),
                                style: TextStyle(color: Colors.black),
                              )
                            : Text(
                                "_",
                                style: TextStyle(color: Colors.black),
                              ),
                      ),
                     
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  if (widget.email != null)
                    Text(
                      widget.email,
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  Text(
                    "",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is UserLoadSuccess) {
          final user = state.user;

          return DrawerHeader(
            padding: EdgeInsets.all(0.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).indicatorColor,
                    Theme.of(context).disabledColor
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (user.profilePic == null)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyProfile(user: user)));
                          },
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.white70,
                            child: (user.userName != null &&
                                    user.userName.length > 0)
                                ? Text(
                                    user.userName[0].toUpperCase(),
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    "_",
                                    style: TextStyle(color: Colors.black),
                                  ),
                          ),
                        ),
                      if (user.profilePic != null)
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyProfile(user: user)));
                            },
                            child: Container(
                                child: ProfileImagee(
                              image: "${baseURL}/api/${user.profilePic}",
                            ))),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  Text(
                    user.userName,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text("Loading");
        }
      },
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
