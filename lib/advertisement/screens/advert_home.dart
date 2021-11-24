import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoticeBoard extends StatefulWidget {
  @override
  NoticeBoardState createState() {
    return new NoticeBoardState();
  }
}

class NoticeBoardState extends State<NoticeBoard> {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "NoticeBoard",
                style: dropDownMenuItemStyle,
              ),
            ],
          ),
        ),
        Container(
          height: 150.0,
          //width: MediaQuery.of(context).size.width,
          child: _buildCitiesList(context),
        ),
      ],
    );
  }
}

Widget _buildCitiesList(BuildContext context) {
  return BlocBuilder<AdvertBloc, AdvertState>(builder: (context, state) {
    if (state is AdvertOperationFailure) {
      return TryAgain();
    }
    if (state is AdvertLoadSuccess) {
      final event = state.advert;
      return event.adverts.isEmpty
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 150),
              child: Center(
                  child: Text(
                "No Record Yet, Start Creating!",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                maxLines: 2,
              )))
          : ListView.builder(
              //shrinkWrap: true,
              itemCount: event.adverts.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, idx) {
                return GestureDetector(
                    onTap: () => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0))),
                                  content: Builder(builder: (context) {
                                    var height =
                                        MediaQuery.of(context).size.height;
                                    var width =
                                        MediaQuery.of(context).size.width;
                                    return Container(
                                      height: height / 2,
                                      width: width / 2,
                                      child: Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Positioned(
                                            right: -40.0,
                                            top: -40.0,
                                            child: InkResponse(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: CircleAvatar(
                                                child: Icon(Icons.close),
                                                backgroundColor: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 25.0,
                                                    ),
                                                    Text(
                                                      event.adverts[idx].topic,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        //height: 1000,
                                                        width: 230,
                                                        child: Text(
                                                          event.adverts[idx]
                                                              .description,
                                                          maxLines: 20,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontFamily:
                                                                "Oxygen",
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                );
                              })
                        },
                    child: _makediscription(
                        Icons.format_list_numbered,
                        event.adverts[idx].description,
                        event.adverts[idx].topic,
                        event.adverts[idx]));
              });
    } else {
      return Container(
        child: CircularIndicat(),
      );
    }
  });
}

_makediscription(
    IconData icon, String text, String text2, AdvertElement advert) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
    //color: Colors.black,
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
              //launch("tel://$text");
            }
            //
            ,
            icon: Icon(
              icon,
              size: 25.0,
              color: Color(0xFF59253A),
            ),
          ),
          SizedBox(width: 10.0),

          Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      text2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        //height: 1000,
                        width: 230,
                        child: Text(
                          text,
                          maxLines: 20,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Oxygen",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),

          //),
        ],
      ),
      // ),
      //],
      // ),
    ),
  );
}
