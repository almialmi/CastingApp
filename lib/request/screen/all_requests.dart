import 'package:appp/lib.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Approve { accept, reject }

class AllRequest extends StatefulWidget {
  final RequestElement element;

  const AllRequest({Key key, this.element}) : super(key: key);

  @override
  _AllRequestState createState() => _AllRequestState();
}

class _AllRequestState extends State<AllRequest> {
  Approve _approve = Approve.accept;
  final Map<String, dynamic> _request = {};
  String dropdownGenderValue;
  RequestElement request;
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final postBloc = BlocProvider.of<RequestBloc>(context);
    if (!(postBloc.state is RequestLoadSuccess)) postBloc.add(RequestLoad());

    return Scaffold(
      appBar: MyAppBar.buildAppbar(context, "Show Requests"),
      body: BlocBuilder<RequestBloc, RequestState>(builder: (context, state) {
        if (state is RequestOperationFailure) {
          return TryAgain();
        }

        // if (!(state is RequestLoadSuccess)) {
        //   final requestBloc = BlocProvider.of<RequestBloc>(context);
        //   requestBloc.add(RequestLoad());
        // }

        if (state is RequestLoadSuccess) {
          // print("ere love");
          final request = state.requests;
          return request.request.isEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 150),
                  child: Center(
                      child: Text(
                    "No Record Found, stay connected!",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    maxLines: 2,
                  )))
              : ListView.builder(
                  itemCount: request.request.length,
                  itemBuilder: (_, idx) => GestureDetector(
                    onTap: () {},
                    child: Dismissible(
                      key: Key('item ${request.request[idx].id}'),
                      background: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(Icons.delete, color: Colors.white),
                              Text('Move to trash',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete Confirmation"),
                              content: const Text(
                                  "Are you sure you want to delete this item?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      context.read<RequestBloc>().add(
                                          RequestDelete(
                                              request.request[idx].id));
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Delete")),
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          print("Add to favorite");
                        } else {
                          print('Remove item');
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestDetail(
                                        request: request.request[idx],
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              // if(request.request[idx].applyer.)
                              if (request.request[idx].applyer.profilePic ==
                                  null)
                                CircleAvatar(
                                  radius: 30.0,

                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  //child: Text("M"),

                                  child: (request.request[idx].applyer
                                                  .userName !=
                                              null &&
                                          request.request[idx].applyer.userName
                                                  .length >
                                              0)
                                      ? Text(
                                          request
                                              .request[idx].applyer.userName[0]
                                              .toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "_",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              if (request.request[idx].applyer.profilePic !=
                                  null)
                                Container(
                                    child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "$baseURL/api/${request.request[idx].applyer.profilePic}",
                                    width: 70,
                                    height: 70,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                  // Image.network(
                                  //   "${baseURL}/api/${request.request[idx].applyer.profilePic}",
                                  //   width: 70,
                                  //   height: 70,
                                  // ),
                                  borderRadius: BorderRadius.circular(100.0),
                                )),

                              SizedBox(
                                width: 12.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      request.request[idx].applyer == null
                                          ? "unknown"
                                          : request
                                              .request[idx].applyer.userName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                    Text(
                                      request.request[idx].applyer.email,
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),

                              Column(
                                children: [
                                  Row(
                                    children: [
                                      if (request.request[idx].approve ==
                                          "Accept")
                                        Icon(
                                          Icons.done_all,
                                          color: Colors.green,
                                        ),
                                      if (request.request[idx].approve ==
                                          "Reject")
                                        Icon(
                                          Icons.close_outlined,
                                          color: Colors.red,
                                        ),
                                      Text("${request.request[idx].approve}"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ),
                );
        } else {
          return CircularIndicat();
        }
      }),
    );
  }

  Widget createDropdown(BuildContext context) {
    return DropdownButton<String>(
      items: <String>['Accept', 'Reject'].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }
}
