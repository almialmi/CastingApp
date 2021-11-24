import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowAdvert extends StatefulWidget {
  @override
  _ShowAdvertState createState() => _ShowAdvertState();
}

class _ShowAdvertState extends State<ShowAdvert> {
  var eventss;
  bool edit = true;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final eventBloc = BlocProvider.of<AdvertBloc>(context);
    if (!(eventBloc.state is AdvertLoadSuccess))
      eventBloc.add(AdvertLoad("Active"));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Column(
          children: [
            Text(
              "all Adverts",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      // appBar: MyAppBar.buildAppbar(context, "all Events"),
      body: BlocBuilder<AdvertBloc, AdvertState>(builder: (context, state) {
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
                  itemCount: event.adverts.length,
                  itemBuilder: (_, idx) {
                    return GestureDetector(
                        onTap: () => {},
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
      }),
    );
  }

  _makediscription(
      IconData icon, String text, String text2, AdvertElement advert) {
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
                  Row(
                    children: [
                      Text(
                        text2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          //color: Colors.black,
                          fontSize: 12.0,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAdvert(
                                      edit: edit, advert: advert)));
                          //  _showPopupMenu(context, event.adverts[idx]);
                        },
                        icon: Icon(
                          Icons.update,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showAlertDialog(context, advert);
                          // _showPopupMenu(context, event.adverts[idx]);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                  Text(
                    text,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, fontFamily: "Oxygen"),
                  ),
                  SizedBox(height: 4.0),

                  //),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showPopupMenu(BuildContext context, EventElement event) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(25.0, 25.0, 0.0,
          0.0), //position where you want to show the menu on screen
      items: [
        PopupMenuItem<String>(
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text("delete"),
            ),
            value: '1'),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          child: ListTile(
            leading: Icon(Icons.update),
            title: Text("update"),
          ),
          value: '2',
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          child: ListTile(
            leading: Icon(Icons.app_registration),
            title: Text("comptition"),
          ),
          value: '3',
        ),
      ],
      elevation: 2.0,
    ).then<void>((String itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        eventss = event.id;
        _showAlertDialog(context, eventss);
        //  BlocProvider.of<IssueBloc>(context).add(IssueDelete(issuee));
        // context.read<IssueBloc>().add(IssueDelete(this.issue));
        //code here
      } else if (itemSelected == "2") {
        print("ere pease ${event.name}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateEvent(edit: edit, event: event)));
      } else if (itemSelected == "3") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateComptition(eventid: event.id)));
      }
    });
  }

  _showAlertDialog(BuildContext context, AdvertElement advert) {
    //print("ere pease ${eventss}");

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        // context.read<CatBloc>().add(
        //     CategoryDelete(cats[idx].id));
        BlocProvider.of<AdvertBloc>(context).add(AdvertDelete(advert.id));
        Navigator.pop(context);
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: Duration(seconds: 15),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("deleting..."),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                ],
              ),
              backgroundColor: Theme.of(context).shadowColor,
            ),
          );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Conformation"),
      content: Text("would you like to delete this event?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
