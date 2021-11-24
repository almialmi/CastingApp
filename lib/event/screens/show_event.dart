import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ShowEvent extends StatefulWidget {
  @override
  _ShowEventState createState() => _ShowEventState();
}

class _ShowEventState extends State<ShowEvent> {
  var eventss;
  bool edit = true;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final eventBloc = BlocProvider.of<EventBloc>(context);
    if (!(eventBloc.state is EventLoadSuccess))
      eventBloc.add(EventLoad("false"));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Column(
          children: [
            Text(
              "all Events",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.tv_off),
        //       onPressed: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => OutDatedEvent()));
        //       })
        // ],
      ),
      // appBar: MyAppBar.buildAppbar(context, "all Events"),
      body: BlocBuilder<EventBloc, EventState>(builder: (context, state) {
        if (state is EventOperationFailure) {
          return TryAgain();
        }
        if (state is EventLoadSuccess) {
          final event = state.events;
          return event.events.isEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 150),
                  child: Center(
                      child: Text(
                    "No Record Yet, Start Creating!",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    maxLines: 2,
                  )))
              : ListView.builder(
                  itemCount: event.events.length,
                  itemBuilder: (_, idx) {
                    
                    return GestureDetector(
                        onTap: () => {},
                        child: Card(
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new ListTile(
                                leading: ProfileImagee(
                                    image:
                                        "${baseURL}/api/${event.events[idx].photo}"),
                                title: new Text(event.events[idx].name),
                                trailing: IconButton(
                                  onPressed: () {
                                    _showPopupMenu(context, event.events[idx]);
                                  },
                                  icon: Icon(
                                    Icons.more_vert,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                  });
        } else {
          return Container(
            child: CircularIndicat(),
          );
        }
      }),
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

  _showAlertDialog(BuildContext context, eventss) {
    print("ere pease ${eventss}");

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
        BlocProvider.of<EventBloc>(context).add(EventDelete(eventss));
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
