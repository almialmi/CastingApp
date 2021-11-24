import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowUsers extends StatefulWidget {
  @override
  _ShowUsersState createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  var eventss;
  bool edit;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final userBloc = BlocProvider.of<PostBloc>(context);
    if (!(userBloc.state is AllUserLoadSuccess)) userBloc.add(AllUserLoad());
    return Scaffold(
      appBar: MyAppBar.buildAppbar(context, "All Users"),
      body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        if (state is PostOperationFailure) {
          return TryAgain();
        }

        if (!(state is AllUserLoadSuccess)) {
          final requestBloc = BlocProvider.of<PostBloc>(context);
          requestBloc.add(AllUserLoad());
        }

        if (state is AllUserLoadSuccess) {
          // print("ere love");
          final user = state.posts;
          return user.post.isEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 150),
                  child: Center(
                      child: Text(
                    "No Record Yet, start Creating!",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    maxLines: 2,
                  )))
              : ListView.builder(
                  itemCount: user.post.length,
                  itemBuilder: (_, idx) => GestureDetector(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailUsers(
                                      post: user.post[idx],
                                    )),
                          ),
                      child: Card(
                          // margin: const EdgeInsets.symmetric(vertical: 100),
                          elevation: 2,
                          //  color: Colors.white70,
                          // shape: RoundedRectangleBorder(
                          // borderRadius: BorderRadius.all(Radius.circular(24))),
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    // Container(
                                    Row(
                                      children: [
                                        //CircleAvatar(
                                        //radius: 30.0,
                                        ProfileImagee(
                                          image:
                                              "${baseURL}/api/${user.post[idx].photo1}",
                                        ),

                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.post[idx].firstName +
                                                  " " +
                                                  user.post[idx].lastName,
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                            Text(
                                              user.post[idx].age.toString(),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        IconButton(
                                            icon: Icon(Icons.update),
                                            onPressed: () {
                                              bool edit = true;

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CreateUsers(
                                                            post:
                                                                user.post[idx],
                                                            edit: edit,
                                                          )));
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              //setState(() {
                                              eventss = user.post[idx].id;
                                              // });
                                              print("dess yilal + $eventss ");

                                              _showAlertDialog(context,
                                                  user.post[idx].categoryId);
                                            }),
                                      ],
                                    ),
                                    // ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ]))))
                  //),
                  );
        } else {
          return Container(
            child: CircularIndicat(),
          );
        }
      }),
    );
  }

  _showAlertDialog(BuildContext context, String categoryID) {
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
        BlocProvider.of<PostBloc>(context).add(PostDelete(eventss, categoryID));
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
      title: Text("Delete Confirmation"),
      content: Text("would you like to delete this user?"),
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
