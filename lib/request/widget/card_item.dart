import 'package:appp/lib.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class CardItem extends StatefulWidget {
  final RequestElement request;
  const CardItem({Key key, this.request}) : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  final Map<String, dynamic> _request = {};
  @override
  Widget build(BuildContext context) {
    String dropdownGenderValue;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          _makefullname(
              Icons.person,
              widget.request.requestedUser.firstName +
                  " " +
                  widget.request.requestedUser.lastName,
              "full name"),
          _makecards(
              Icons.call, widget.request.requestedUser.mobile, "phone number"),
          // makeemail(
          //     Icons.date_range,
          //     widget.request.dateForWork != null
          //         ? widget.request.dateForWork
          //         : "",
          //     "date forwork"),
          _makeduration(
              Icons.format_list_numbered, widget.request.duration, "duration"),
          _makediscription(
              Icons.description, widget.request.description, "description"),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  // wrap your Column in Expanded
                  child: Column(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(),
                          child: Text("Accept or Reject")),
                    ],
                  ),
                ),
                Expanded(
                  // wrap your Column in Expanded
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(),
                        child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Please select request';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Select gender',
                              border: OutlineInputBorder(),
                              labelText: 'Choose',
                              fillColor: Colors.white,
                            ),
                            isExpanded: true,
                            value: dropdownGenderValue,
                            items: <String>['Accept', 'Reject']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dropdownGenderValue = value;
                                this._request['approve'] = value;
                                print("this is gender: $value");

                                // _issue.category = value;
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              child: DefaultButton(
                  text: "Submit",
                  press: () async {
                    // this._request["approve"] = ;
                    final RequestEvent event = RequestUpdate(RequestElement(
                      id: widget.request.id,
                      approve: this._request['approve'],
                    ));

                    BlocProvider.of<RequestBloc>(context).add(event);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllRequest()));
                  }))
        ]));
  }

  makeemail(IconData icon, DateTime text, String text2) {
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
                launch("mailto:$text");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${formatDate(text, [yyyy, '-', mm, '-', dd])}",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Oxygen'),
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

  _makefullname(IconData icon, String text, String text2) {
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
                // launch(
                //     "https://www.google.com/maps/search/${Uri.encodeFull("$text")}");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Oxygen'),
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

  _makecards(IconData icon, String text, String text2) {
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
                launch("tel://$text");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(fontSize: 18.0, fontFamily: "Oxygen"),
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

  _makediscription(IconData icon, String text, String text2) {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    text,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, fontFamily: "Oxygen"),
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
    );
  }

  _makeduration(IconData icon, String text, String text2) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(fontSize: 16.0, fontFamily: "Oxygen"),
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
