import 'package:appp/lib.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SentRequest extends StatefulWidget {
  final String applyer;

  const SentRequest({Key key, this.applyer}) : super(key: key);
  @override
  _SentRequestState createState() => _SentRequestState();
}

class _SentRequestState extends State<SentRequest> {
  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<RequestBloc>(context);
    if (!(postBloc.state is RequestLoadSuccess)) postBloc.add(MyRequestLoad());

    return Scaffold(
      appBar: MyAppBar.buildAppbar(context, "My requests"),
      body: BlocBuilder<RequestBloc, RequestState>(builder: (context, state) {
        if (state is RequestOperationFailure) {
          return TryAgain();
        }

        if (state is RequestLoadSuccess) {
          final request = state.requests;
          return request.request.isEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 150, horizontal: 10),
                  child: Center(
                      child: Text(
                    "No Record Found , Start Sending Requests! and you will have them right here.",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    maxLines: 2,
                  )))
              : ListView.builder(
                  itemCount: request.request.length,
                  itemBuilder: (_, idx) {
                   
                    return GestureDetector(
                      onTap: () {
                        
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            ProfileImagee(
                              image:
                                  "$baseURL/api/${request.request[idx].requestedUser.photo1}",
                            ),

                            SizedBox(
                              width: 15.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.request[idx].applyer == null
                                      ? "unknown"
                                      : request.request[idx].requestedUser
                                              .firstName +
                                          " " +
                                          request.request[idx].requestedUser
                                              .lastName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                Text(
                                    "${formatDate(request.request[idx].dateForWork, [
                                  yyyy,
                                  '-',
                                  mm,
                                  '-',
                                  dd
                                ])}")
                                //Text("${request.request[idx].dateForWork}")
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                if (request.request[idx].approve == "Accept")
                                  Icon(
                                    Icons.done_all,
                                    color: Colors.green,
                                  ),
                                if (request.request[idx].approve == "Reject")
                                  Icon(
                                    Icons.close_outlined,
                                    color: Colors.red,
                                  ),
                                Text("${request.request[idx].approve}"),
                              ],
                            ),
                           
                          ],
                        ),
                      ),
                    );
                  });
        } else {
          return CircularIndicat();
        }
      }),
    );
  }
}
