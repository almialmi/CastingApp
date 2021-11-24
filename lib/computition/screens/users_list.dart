import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersList extends StatefulWidget {
  final String eventid;

  const UsersList({Key key, this.eventid}) : super(key: key);
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  var isSelected = false;
  var mycolor = Colors.white;
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final userBloc = BlocProvider.of<PostBloc>(context);
    if (!(userBloc.state is AllUserLoadSuccess)) userBloc.add(AllUserLoad());
    return Scaffold(
      appBar: MyAppBar.buildAppbar(context, "Select User"),
      body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        if (state is PostOperationFailure) {
          return TryAgain();
        }

        if (state is AllUserLoadSuccess) {
          // print("ere love");
          final user = state.posts;
          return ListView.builder(
              itemCount: user.post.length,
              itemBuilder: (_, idx) => GestureDetector(
                  onLongPress: () => {toggleSelection},
                 
                  child:
                    
                      Card(
                    
                    child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new ListTile(
                              selected: isSelected,
                              leading: ProfileImagee(
                                  image:
                                      "${baseURL}/api/${user.post[idx].photo1}"),
                              title: new Text(user.post[idx].firstName +
                                  " " +
                                  user.post[idx].lastName),
                             
                              onLongPress: () {
                                toggleSelection;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateComptition(
                                              user: user.post[idx],
                                              eventid: widget.eventid,
                                            )));
                              } // what should I put here,
                              )
                        ]),
                  )
                  //])
                  // )
                  ));
         
        } else {
          return CircularIndicat();
        }
      }),
    );
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = Colors.white;
        isSelected = false;
      } else {
        mycolor = Colors.grey[300];
        isSelected = true;
      }
    });
  }
}
