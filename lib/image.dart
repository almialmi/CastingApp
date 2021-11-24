

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class Image {

//    Future<void> _pickImage(ImageSource source) async {
//     File selected = await ImagePicker.pickImage(source: source);
//     if (selected == null) {
//       Scaffold.of(context).showSnackBar(SnackBar(
//         content: Text("No image is selected"),
//       ));
//       return;
//     }
//     setState(() {
//       //this.imagefile.add(selected);
//       //this.imageCount = this.imageFile.length;
//       _cropImage(selected);
//     });
//   }
//    Widget bottomsheet(BuildContext context) {
//     return Container(
//       height: 100,
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
//       child: Column(
//         children: [
//           Text(
//             "choose picture for category",
//             style: TextStyle(fontSize: 20.0),
//           ),
//           SizedBox(
//             height: 10.0,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FlatButton.icon(
//                   onPressed: () {
//                     _pickImage(ImageSource.camera);
//                   },
//                   icon: Icon(Icons.camera_alt),
//                   label: Text("Camera")),
//               FlatButton.icon(
//                   onPressed: () {
//                     _pickImage(ImageSource.gallery);
//                   },
//                   icon: Icon(Icons.photo),
//                   label: Text("Gallery"))
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

