import 'package:appp/lib.dart';
import 'package:appp/posts/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateComptition extends StatefulWidget {
  final String eventid;
  final PostElement user;

  const CreateComptition({
    Key key,
    this.user,
    this.eventid,
  }) : super(key: key);
  @override
  _CreateComptitionState createState() => _CreateComptitionState();
}

class _CreateComptitionState extends State<CreateComptition> {
  BuildContext scaffoldContext;
  final Map<String, dynamic> _comps = {};
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar.buildAppbar(context, "Users Forcomptition"),
        body: Builder(builder: (BuildContext context) {
          scaffoldContext = context;
          return Container(
            height: 600,
            child: Form(
              key: _formKey,
              child: Container(
                height: 100,
                margin: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: Container(
                  margin: EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
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
                                      child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: 'MFE4UIBNAs0',
                                            border: OutlineInputBorder(),
                                            labelText: 'Vedio link id',
                                            fillColor: Colors.white,
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Please enter your vedio link';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) =>
                                              this._comps['video'] = value),
                                    ),
                                    // )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                // wrap your Column in Expanded
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(),
                                      child: FlatButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UsersList(
                                                            eventid: widget
                                                                .eventid)));
                                          },
                                          icon: Icon(Icons.person),
                                          label: Text(widget.user == null
                                              ? "add user"
                                              : "selected:  \n${widget.user.firstName}")),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          child: DefaultButton(
                              text: "Submit",
                              press: () async {
                                if (_formKey.currentState.validate()) {
                                  final CompEvent event =
                                      CompCreate(COmputationPost(
                                    userid: widget.user.id,
                                    eventid: widget.eventid,
                                    video: this._comps['video'],
                                  ));

                                  BlocProvider.of<CompBloc>(context).add(event);

                                  Scaffold.of(scaffoldContext)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 6),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('created Succesfully!'),
                                            Icon(Icons.info),
                                          ],
                                        ),
                                        backgroundColor: Color(0xFF59253A),
                                      ),
                                    );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreenn(),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
