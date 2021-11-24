import 'package:appp/advertisement/screens/show_adverts.dart';
import 'package:appp/lib.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAdvert extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafoldkey;

  final bool edit;
  final AdvertElement advert;

  CreateAdvert({this.edit, this.advert, this.scafoldkey});

  @override
  _CreateAdvertState createState() => _CreateAdvertState();
}

class _CreateAdvertState extends State<CreateAdvert> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _advert = {};

  @override
  Widget build(BuildContext context) {
    String dropdownGenderValue;
    return Scaffold(
      appBar: MyAppBar.buildAppbar(context,
          "${widget.edit == true ? "Update Advert" : "Create Advert"} "),
      body: BlocListener<AdvertBloc, AdvertState>(
        listener: (context, state) {
          // if (state is Categoryfailed) {
          //   Scaffold.of(context)
          //     ..removeCurrentSnackBar()
          //     ..showSnackBar(
          //       SnackBar(
          //         content: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: <Widget>[
          //             Text("Category creation failed"),
          //             Icon(Icons.error),
          //           ],
          //         ),
          //         backgroundColor: Colors.white70,
          //       ),
          //     );
          // }
          // TODO: implement listener
        },
        child: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: TextFormField(
                            maxLength: 8,
                            initialValue:
                                widget.edit == true ? widget.advert.topic : "",
                            decoration: const InputDecoration(
                              hintText: 'eg:- Registration for Modeling',
                              border: OutlineInputBorder(),
                              labelText: 'Topic',
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Topic';
                              }
                              return null;
                            },
                            onChanged: (value) => this._advert['topic'] = value
                            //  double.parse(value),
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: TextFormField(
                            maxLines: 10,
                            initialValue: widget.edit == true
                                ? widget.advert.description
                                : "",
                            decoration: const InputDecoration(
                              hintText: 'eg:- description',
                              border: OutlineInputBorder(),
                              labelText: 'Description',
                              fillColor: Colors.white,
                            ),
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'Please enter Description';
                            //   }
                            //   return null;
                            // },
                            onChanged: (value) =>
                                this._advert['description'] = value
                            //  double.parse(value),
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    if (widget.edit == true)
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
                                      child: Text("Accept or Reject")),
                                ],
                              ),
                            ),
                            Expanded(
                              // wrap your Column in Expanded
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: DropdownButtonFormField(
                                        // validator: (value) {
                                        //   if (value == null) {
                                        //     return 'Please select status';
                                        //   }
                                        //   return null;
                                        // },
                                        decoration: const InputDecoration(
                                          hintText: 'Select status',
                                          border: OutlineInputBorder(),
                                          labelText: 'Choose',
                                          fillColor: Colors.white,
                                        ),
                                        isExpanded: true,
                                        value: dropdownGenderValue,
                                        items: <String>['Active', 'Closed']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            child: Text(value),
                                            value: value,
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownGenderValue = value;
                                            this._advert['status'] = value;
                                            print("this is gender: $value");

                                            // _issue.category = value;
                                          });
                                        }),
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
                    DefaultButton(
                      text: "submit",
                      press: () {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();

                          final AdvertEvent event = widget.edit == true
                              ? AdvertUpdate(
                                  AdvertElement(
                                      id: widget.advert.id,
                                      topic: this._advert["topic"] == null
                                          ? widget.advert.topic
                                          : this._advert["topic"],
                                      description:
                                          this._advert["description"] == null
                                              ? widget.advert.description
                                              : this._advert["description"],
                                      status: this._advert["status"] == null
                                          ? "Active"
                                          : this._advert["status"]),
                                )
                              : AdvertCreate(
                                  AdvertElement(
                                    topic: this._advert["topic"],
                                    description: this._advert["description"],
                                  ),
                                );
                          BlocProvider.of<AdvertBloc>(context).add(event);
                          if (widget.edit != true)
                            Scaffold.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 10),
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Creating..."),
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    ],
                                  ),
                                  backgroundColor:
                                      Theme.of(context).shadowColor,
                                ),
                              );
                          _formKey.currentState.reset();
                          if (widget.edit == true)
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowAdvert(),
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
