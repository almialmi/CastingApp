import 'dart:io';
import 'package:appp/lib.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';

class CreateEvent extends StatefulWidget {
  final bool edit;

  final EventElement event;

  const CreateEvent({this.edit, this.event});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedendDate = DateTime.now();

  TextEditingController dateendCtl = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  static final baseUrl = 'http://192.168.43.202:3000';
  String selectedcat;
  String cookieValue;
  // ignore: deprecated_member_use
  List data = List();
 

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _event = {};
  File _image;
  final picker = ImagePicker();

  _goBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future getImage() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _cropImage(imageFile) async {
    if (imageFile == null) {
      return;
    }
    File cropped = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        ratioX: 4.0,
        ratioY: 3.0,
        // maxWidth: 512,
        // maxHeight: 512,
        toolbarColor: Colors.black87,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It');

    setState(() {
      this._image = cropped ?? imageFile;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    if (selected == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No image is selected"),
      ));
      return;
    }
    setState(() {
      //this.imagefile.add(selected);
      //this.imageCount = this.imageFile.length;
      _cropImage(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.buildAppbar(
          context, "${widget.edit == true ? "Update Event" : "Create Event"}"),
      body: Container(
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
                      //child:
                      // decoration: BoxDecoration(),
                      child: TextFormField(
                        maxLength: 13,
                        initialValue:
                            widget.edit == true ? widget.event.name : "",
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Enter eventName here',
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        onChanged: (value) => this._event['name'] = value,
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
                                    controller: dateCtl,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "start date",
                                      hintText: "dd-mm-yyyy",
                                    ),
                                    onTap: () async {
                                      DateTime date = DateTime(1900);
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());

                                      date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));

                                      dateCtl.text = "${formatDate(date, [
                                        yyyy,
                                        '-',
                                        mm,
                                        '-',
                                        dd
                                      ])}";

                                      setState(() {
                                        selectedDate = date.toLocal();
                                      });
                                    },
                                    validator: (value) {
                                      if (widget.edit != true) if (value
                                          .isEmpty) {
                                        return 'Please enter startDate';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) =>
                                        this._event['startDate'] = selectedDate,

                                    // double.parse(value),
                                  ),
                                ),
                                //)),
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
                                    // initialValue:
                                    //   widget.eventenddate.toString(),
                                    controller: dateendCtl,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "end date",
                                      hintText: "dd-mm-yyyy",
                                    ),
                                    onTap: () async {
                                      DateTime date = DateTime(1900);
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());

                                      date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));

                                      dateendCtl.text = "${formatDate(date, [
                                        yyyy,
                                        '-',
                                        mm,
                                        '-',
                                        dd
                                      ])}";

                                      setState(() {
                                        selectedendDate = date.toLocal();
                                      });
                                    },

                                    validator: (value) {
                                      if (widget.edit != true) if (value
                                          .isEmpty) {
                                        return 'Please enter endDate';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => this
                                        ._event['endDate'] = selectedendDate,

                                    // double.parse(value),
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
                                  this._event['category'] = value;
                                  print("this is id: ${value} ");

                                  // _issue.category = value;
                                  //
                                  //
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
                    Stack(
                      children: <Widget>[
                        if (widget.edit != true)
                          Container(
                            // decoration: new BoxDecoration(color: Colors.white),
                            alignment: Alignment.centerRight,
                            height: 100,

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: _image == null
                                  ? Image.asset("assets/images/modell.jpg")
                                  : Image.file(_image, fit: BoxFit.fill),
                            ),
                          ),
                        if (widget.edit == true)
                          Container(
                            // decoration: new BoxDecoration(color: Colors.white),
                            alignment: Alignment.centerRight,
                            height: 100,

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: _image == null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          "${baseURL}/api/${widget.event.photo}",
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                    )
                                  // Image.network(src)(Uint8List.fromList(
                                  //     widget.event.photo.data.data))
                                  : Image.file(_image, fit: BoxFit.fill),
                            ),
                          ),
                        Positioned.fill(
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  iconSize: 50,
                                  icon: Icon(Icons.add_a_photo),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return bottomsheet();
                                        });
                                  })),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      //child:
                      // decoration: BoxDecoration(),
                      child: TextFormField(
                        initialValue:
                            widget.edit == true ? widget.event.description : "",
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Enter discription here',
                          border: OutlineInputBorder(),
                          labelText: 'Discription',
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter discription';
                          }
                          return null;
                        },
                        onChanged: (value) =>
                            this._event['description'] = value,
                      ),
                    ),
                    // ),
                    SizedBox(
                      height: 20.0,
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    // ImageCapture(
                    //   imageFile: this.images,
                    // ),

                    Container(
                        child: DefaultButton(
                      text: "Submit",
                      press: () async {
                        print("the date is $selectedDate");
                        if (_formKey.currentState.validate()) {
                          print("ere bakhn  ${this._event["category"]}");
                          //  _issue.images = this.images;

                          final EventEvent event = widget.edit == true
                              ? _image == null
                                  ? EventUpdatenotPic(
                                      EventElement(
                                        id: widget.event.id,
                                        name: this._event["name"] == null
                                            ? widget.event.name
                                            : this._event["name"],
                                        description:
                                            this._event["description"] == null
                                                ? widget.event.description
                                                : this._event["description"],
                                        categoryId:
                                            this._event["category"] == null
                                                ? widget.event.categoryId
                                                : this._event["category"],
                                        startDate: selectedDate == null
                                            ? widget.event.startDate
                                            : selectedDate,
                                        endDate: selectedendDate == null
                                            ? widget.event.endDate
                                            : selectedendDate,
                                      ),
                                    )
                                  : EventUpdate(
                                      EventElement(
                                        id: widget.event.id,
                                        name: this._event["name"] == null
                                            ? widget.event.name
                                            : this._event["name"],
                                        description:
                                            this._event["description"] == null
                                                ? widget.event.description
                                                : this._event["description"],
                                        categoryId:
                                            this._event["category"] == null
                                                ? widget.event.categoryId
                                                : this._event["category"],
                                        startDate: selectedDate == null
                                            ? widget.event.startDate
                                            : selectedDate,
                                        endDate: selectedendDate == null
                                            ? widget.event.endDate
                                            : selectedendDate,
                                      ),
                                      _image)
                              : EventCreate(
                                  EventElement(
                                    name: this._event["name"],
                                    description: this._event["description"],
                                    categoryId: this._event["category"],
                                    startDate: selectedDate == null
                                        ? widget.event.startDate
                                        : selectedDate,
                                    endDate: selectedendDate == null
                                        ? widget.event.endDate
                                        : selectedendDate,
                                  ),
                                  _image == null ? widget.event.photo : _image);

                          BlocProvider.of<EventBloc>(context).add(event);
                          if (widget.edit != true) {
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
                          }
                          if (widget.edit == true) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowEvent(),
                              ),
                            );
                          }
                          
                        }
                      },
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Text(
            "choose picture for event",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text("Camera")),
              FlatButton.icon(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.photo),
                  label: Text("Gallery"))
            ],
          )
        ],
      ),
    );
  }
}
