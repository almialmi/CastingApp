import 'dart:io';
import 'package:appp/advertisement/screens/advert_dashboard.dart';
import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CustomDrawer extends StatefulWidget {
  final File imagefile;

  const CustomDrawer({Key key, this.imagefile}) : super(key: key);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class LinearGradientMask extends StatelessWidget {
  LinearGradientMask({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 1,
          colors: [Color(0xff6a515e), Color(0xff6a515e)],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class _CustomDrawerState extends State<CustomDrawer> {
  File imagefile;
  String email;
  String role_user;
  String applyer;

  /// Cropper plugin
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
      //this.imagefile.add(selected);
      //this.imageCount = this.imageFile.length;
      _cropImage(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    SharedPrefHandler.getrolevalue().then((value) => ROLE = value);
    //print("this is fucking $ROLE");
    // SharedPrefUtils.getidvalue().then((id) {
    //   applyer = id;
    // });
    // SharedPrefHandler.getrolevalue().then((role) {
    //   setState(() {
    //     role_user = role;
    //   });
    // });
    SharedPrefUtils.getemailvalue().then((email) {
      setState(() {
        email = email;
      });
    });
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Header(email: email),
          ListTile(
            leading:
                LinearGradientMask(child: Icon(Icons.home, color: Colors.grey)),
            title: Text("Home"),
            onTap: () {
              print("Home Clicked $role_user");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreenn()),
              );
            },
          ),
          if (ROLE == "Admin")
            ListTile(
              leading: LinearGradientMask(
                  child: Icon(Icons.people, color: Colors.grey)),
              title: Text("Advertisment"),
              onTap: () {
                print("new issues Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdvertDashboard()),
                );
              },
            ),
          if (ROLE == "Admin")
            ListTile(
              leading: LinearGradientMask(
                  child: Icon(Icons.people, color: Colors.grey)),
              title: Text("Users"),
              onTap: () {
                print("new issues Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserDashboard()),
                );
              },
            ),
          if (ROLE == "Admin")
            ListTile(
              leading: LinearGradientMask(
                  child: Icon(Icons.category, color: Colors.grey)),
              title: Text("Category"),
              onTap: () {
                print("my issues Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CatDashboard()),
                );
              },
            ),
          if (ROLE == "Admin")
            ListTile(
              leading: LinearGradientMask(
                  child: Icon(Icons.event, color: Colors.grey)),
              title: Text("Event"),
              onTap: () {
                print("my issues Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventDashboard()),
                );
              },
            ),
          if (ROLE == "Admin")
            ListTile(
              leading: LinearGradientMask(
                  child:
                      Icon(Icons.remove_red_eye_outlined, color: Colors.grey)),
              title: Text("show Requests"),
              onTap: () {
                print("my issues Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllRequest()),
                );
              },
            ),
          ListTile(
            leading: LinearGradientMask(
                child: Icon(Icons.remove_red_eye_outlined, color: Colors.grey)),
            title: Text("my Requests"),
            onTap: () {
              print("my issues Clicked");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SentRequest(applyer: applyer)),
              );
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: LinearGradientMask(
                child: Icon(Icons.details, color: Colors.grey)),
            title: Text("about us"),
            onTap: () {
              print("Add Clicked");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationNotAuthenticated) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              userRepository: UserRepository(),
                            )));
              }
            },
            child: ListTile(
              leading: LinearGradientMask(
                  child: Icon(Icons.logout, color: Colors.grey)),
              title: Text("Log out"),
              onTap: () async {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(UserLoggedOut());
                var appDir = (await getApplicationDocumentsDirectory()).path;
                new Directory(appDir).delete(recursive: true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget imageprofile() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: imagefile == null
                ? AssetImage("assets/images/even.jpg")
                : FileImage(File(imagefile.path)),
          ),
          Positioned(
            bottom: 10.0,
            right: 0.0,
            left: 70.0,
            child: IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return bottomsheet();
                    });
              },
            ),
          )
        ],
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
