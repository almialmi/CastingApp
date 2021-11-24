import 'dart:io';
import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateIdeaForm extends StatefulWidget {
  final bool edit;
  final PostElement post;

  const CreateIdeaForm({
    Key key,
    this.edit,
    this.post,
  }) : super(key: key);
  @override
  _CreateIdeaFormState createState() => _CreateIdeaFormState();
}

class _CreateIdeaFormState extends State<CreateIdeaForm> {
  String cookieValue;

  String dropdownGenderValue;
  static final baseUrl = 'http://10.9.215.220:3000';
  String selectedcat;

  final Map<String, dynamic> _posts = {};
  List<String> categories = [];
  List<File> images = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                                    initialValue: widget.edit == true
                                        ? widget.post.firstName
                                        : "",
                                    decoration: const InputDecoration(
                                      hintText: 'eg Abebe',
                                      border: OutlineInputBorder(),
                                      labelText: 'FirstName',
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter user firstName';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) =>
                                        this._posts['firstName'] = value),
                              ),
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
                                child: TextFormField(
                                    initialValue: widget.edit == true
                                        ? widget.post.lastName
                                        : "",
                                    decoration: const InputDecoration(
                                      hintText: 'eg: Kebede',
                                      border: OutlineInputBorder(),
                                      labelText: 'LastName',
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter user lastName';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) =>
                                        this._posts['lastName'] = value),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
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
                                    initialValue: widget.edit == true
                                        ? widget.post.mobile
                                        : "",
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: 'eg:- 0913503098',
                                      border: OutlineInputBorder(),
                                      labelText: 'Phone Number',
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter phone number';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) =>
                                        this._posts['mobile'] = value
                                    //double.parse(value),
                                    ),
                              ),
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
                                child: TextFormField(
                                    initialValue: widget.edit == true
                                        ? widget.post.age
                                        : "",
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: const InputDecoration(
                                      hintText: 'eg: 28',
                                      border: OutlineInputBorder(),
                                      labelText: 'Age',
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter user age';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) =>
                                        this._posts['age'] = value
                                    //  double.parse(value),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(children: [
                    BlocBuilder<CatBloc, CatState>(builder: (context, state) {
                      if (state is CategoryLoadSuccess) {
                        // print("ere love");
                        final cats = state.cats;
                        return DropdownButtonFormField(
                            decoration: const InputDecoration(
                              hintText: 'Select Casting category',
                              border: OutlineInputBorder(),
                              labelText: 'Category',
                              fillColor: Colors.white,
                            ),
                            isExpanded: true,
                            value: selectedcat,
                            items: cats.map((list) {
                              return DropdownMenuItem(
                                child: Text("${list.name}"),
                                value: list.id,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedcat = value;
                                this._posts['category'] = value;
                                print("this is id: ${value} ");
                              });
                            });
                      } else {
                        return Text("");
                      }
                    })
                  ]),
                  SizedBox(
                    height: 20.0,
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
                                child: DropdownButtonFormField(
                                    // validator: (value) {
                                    //   if (value == null) {
                                    //     return 'Please select gender';
                                    //   }
                                    //   return null;
                                    // },
                                    decoration: const InputDecoration(
                                      hintText: 'Select gender',
                                      border: OutlineInputBorder(),
                                      labelText: 'Gender',
                                      fillColor: Colors.white,
                                    ),
                                    isExpanded: true,
                                    value: dropdownGenderValue,
                                    items: <String>['Female', 'Male']
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
                                        this._posts['gender'] = value;
                                        print("this is gender: $value");

                                        // _issue.category = value;
                                      });
                                    }),
                              ),
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
                                child: TextFormField(
                                    initialValue: widget.edit == true
                                        ? widget.post.video
                                        : "",
                                    decoration: const InputDecoration(
                                      hintText:
                                          'https://www.youtube.com/watch?v=7QxLFlbUHYk',
                                      border: OutlineInputBorder(),
                                      labelText: 'Youtube_link',
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter youtube link';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) =>
                                        this._posts['video'] = value
                                    //  double.parse(value),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (widget.edit != true)
                    ImageCapture(
                      imageFile: this.images,
                    ),
                  Container(
                      child: DefaultButton(
                    text: "Submit",
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        //_issue.images = this.images;

                        final PostEvent event = widget.edit == true
                            ? ProfileUpdate(
                                PostElement(
                                  id: widget.post.id,
                                  firstName: this._posts['firstName'] == null
                                      ? widget.post.firstName
                                      : this._posts['firstName'],
                                  lastName: this._posts['lastName'] == null
                                      ? widget.post.lastName
                                      : this._posts['lastName'],
                                  age: this._posts['age'] == null
                                      ? widget.post.age
                                      : this._posts['age'],
                                  gender: this._posts['gender'] == null
                                      ? widget.post.gender
                                      : this._posts['gender'],
                                  categoryId: this._posts['category'] == null
                                      ? widget.post.categoryId
                                      : this._posts['category'],
                                  // Category.fromJson(this._posts['category']),
                                  // category: this._posts['category'],
                                  mobile: this._posts['mobile'] == null
                                      ? widget.post.mobile
                                      : this._posts['mobile'],
                                  video: this._posts['video'] == null
                                      ? widget.post.video
                                      : this._posts['video'],
                                ),
                                this._posts['category'],
                              )
                            : PostCreate(
                                PostElement(
                                  firstName: this._posts['firstName'],
                                  lastName: this._posts['lastName'],
                                  age: this._posts['age'],
                                  gender: this._posts['gender'],
                                  categoryId: this._posts['category'],
                                  // Category.fromJson(this._posts['category']),
                                  // category: this._posts['category'],
                                  mobile: this._posts['mobile'],
                                  video: this._posts['video'],
                                ),
                                images,
                                this._posts["category"]);

                        BlocProvider.of<PostBloc>(context).add(event);
                        //_product.images = this.images;
                        //await _product.save();

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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  ],
                                ),
                                backgroundColor: Theme.of(context).shadowColor,
                              ),
                            );
                        _formKey.currentState.reset();
                        if (widget.edit == true)
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowUsers(),
                            ),
                          );

                        // Scaffold.of(context).showSnackBar(
                        //     SnackBar(content: Text('Processing Data')));
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ShowUsers(),
                        //   ),
                        // );
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomeScreen()));
                      }
                    },
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
