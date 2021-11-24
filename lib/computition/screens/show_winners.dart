import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowWinners extends StatelessWidget {
  final String eventid;

  const ShowWinners({Key key, this.eventid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final postBloc = BlocProvider.of<CompBloc>(context);
    postBloc.add(WinnersLoad(eventid));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            "Winners",
            style: new TextStyle(color: Colors.black),
          ),
          actions: [],
          // leading: new IconButton(
          //   icon: new Icon(Icons.arrow_back),
          //   color: Colors.black,
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => HomeScreenn()),
          //     );
          //},
        ),
        // ),
        //appBar: MyAppBar.buildAppbar(context, "Winners"),
        body: BlocBuilder<CompBloc, CompState>(
            // ignore: missing_return
            builder: (context, state) {
          if (state is CompOperationFailure) {
            return TryAgain();
          }

          if (state is WinnersLoadSuccess) {
            final compute = state.comps;
            return compute.computationPosts.isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 150),
                    child: Center(
                        child: Text(
                      "No Record Found, stay connected!",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      maxLines: 2,
                    )))
                : ListView.builder(
                    itemCount: compute.computationPosts.length,
                    itemBuilder: (_, idx) =>
                        WinnersDetail(comps: compute.computationPosts[idx]));
          } else {
            return CircularIndicat();
          }
        }));
  }
}
