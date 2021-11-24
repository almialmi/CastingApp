// import 'dart:io';
// import 'package:appp/lib.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class NoticeBoard extends StatefulWidget {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   _NoticeBoardState createState() => _NoticeBoardState();
// }

// class _NoticeBoardState extends State<NoticeBoard> {
  
//   @override
//   Widget build(BuildContext context) {
    
    
//       return BlocListener<CatBloc, CatState>(
//           listener: (context, state) {},
//           child: BlocBuilder<CatBloc, CatState>(builder: (context, state) {
//             if (state is CategoryOperationFailure) {
//               return TryAgain();
//             }

//             if (!(state is CategoryLoadSuccess)) {
//               catBloc.add(CategoryLoad());
//             }

//             if (state is CategoryLoadSuccess) {
//               final cats = state.cats;
//               return cats.isEmpty
//                   ? Container(
//                       padding: EdgeInsets.symmetric(vertical: 150),
//                       child: Center(
//                           child: Text(
//                         " ",
//                         style: TextStyle(color: Colors.grey, fontSize: 16),
//                         maxLines: 2,
//                       )))
//                   : ListView.builder(
//                       itemCount: cats.length,
//                       itemBuilder: (_, idx) {
//                         return GestureDetector(
//                             onTap: () => {},
//                             child: Card(
//                                 elevation: 2,
//                                 child: Padding(
//                                     padding: const EdgeInsets.all(5),
//                                     child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.stretch,
//                                         children: <Widget>[
//                                           Container(
//                                             child: Row(
//                                               children: [
                                               
//                                                 Text(
//                                                   cats[idx].name,
//                                                   style:
//                                                       TextStyle(fontSize: 16.0),
//                                                 ),
//                                                 Spacer(),
                                                
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10.0,
//                                           ),
//                                           SizedBox(
//                                             height: 10.0,
//                                           ),
//                                         ]))));
//                       });
//             } else {
//               return Container(
//                 child: CircularIndicat(),
//               );
//             }
//           }));
//        // ));
//   }

  

// }
