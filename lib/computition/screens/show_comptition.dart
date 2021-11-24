import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowComptition extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String eventid;

  ShowComptition({Key key, this.eventid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white70,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowWinners(eventid: eventid)));
                })
          ],
        ),
        body: BlocBuilder<CompBloc, CompState>(
            // ignore: missing_return
            builder: (context, state) {
          if (state is CompOperationFailure) {
            return TryAgain();
          }
          //   return CreateIdeaForm();
          // },
          if (state is CompLoadSuccess) {
            // print("ere love");
            final compute = state.comps;
            return compute.cOmputationPosts.isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 150),
                    child: Center(
                        child: Text(
                      "No Record Found, stay connected!",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      maxLines: 2,
                    )))
                : ListView.builder(
                    itemCount: compute.cOmputationPosts.length,
                    itemBuilder: (_, idx) => ComputeDetail(
                        scafoldkey: _scaffoldKey,
                        comps: compute.cOmputationPosts[idx],
                        eventid: eventid));
          } else {
            return CircularIndicat();
          }
        }));
  }
}
