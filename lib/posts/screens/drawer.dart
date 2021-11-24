
import 'package:appp/lib.dart';
import 'package:flutter/material.dart';

class DrawerAbove extends StatelessWidget {
  final Userr user;
  const DrawerAbove({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Color(0xFF59253A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  //  print("le ailah: ${user.profilePic.data.data}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfile(user: user)));
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/model.jpg"),
                  // child: ClipOval(child: Image.asset("assets/images/model.jpg")
                  // Image.memory(
                  // Uint8List.fromList(user.profilePic.data.data)),
                ),
              ),
              // ),

              
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            user.email,
            style: TextStyle(fontSize: 16.0),
          ),
          Text(user.userName),
        ],
      ),
    );
  }
}
