import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OutDatedEvent extends StatefulWidget {
  @override
  _OutDatedEventState createState() => _OutDatedEventState();
}

class _OutDatedEventState extends State<OutDatedEvent> {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    // final eventBloc = BlocProvider.of<EventBloc>(context);
    // if (!(eventBloc.state is EventLoadSuccess))
    //   eventBloc.add(EventLoad("false"));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreenn())),
        ),
        title: Column(
          children: [
            Text(
              "outDated Events",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.tv_off), onPressed: () {})],
      ),
      // appBar: MyAppBar.buildAppbar(context, "all Events"),
      body: BlocBuilder<EventBloc, EventState>(builder: (context, state) {
        if (state is EventOperationFailure) {
          return TryAgain();
        }

        if (state is EventLoadSuccess) {
          // print("ere love");
          final event = state.events;
          return ListView.builder(
            itemCount: event.events.length,
            itemBuilder: (_, idx) => 
            GestureDetector(
                // onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => HomeScreen()),
                //     ),
                child: Card(
                  color: Colors.white,
                  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new ListTile(
                            leading: ProfileImagee(
                                image:"${baseURL}/api/${event.events[idx].photo}"
                                 //event.events[idx].photo.data.data
                                 ),
                            title: new Text(event.events[idx].name),
                            //subtitle: new Text(" "),
                            trailing: IconButton(
                              onPressed: () {
                                _showAlertDialog(context, event.events[idx]);
                              },
                              icon: Icon(
                                Icons.delete,
                              ),
                              // onLongPress: () {
                              //   toggleSelection;
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => CreateComptition(
                              //                 user: user.post[idx],
                              //                 eventid: widget.eventid,
                              //               )));
                              // } // what should I put here,
                            ))
                      ]),
                )),
          );
        } else {
          return Container(
            child: CircularIndicat(),
          );
        }
      }),
    );
  }

  _showAlertDialog(BuildContext context, EventElement event) {
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
        BlocProvider.of<EventBloc>(context).add(EventDelete(event.id));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreenn()));
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
