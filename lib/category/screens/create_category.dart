import 'dart:io';
import 'package:appp/lib.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreateCategory extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafoldkey;
 
  final bool edit;
  final Category cat;
 
  CreateCategory({this.edit, this.cat, this.scafoldkey});

  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _cat = {};
  File _image;
  final picker = ImagePicker();

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
      appBar: MyAppBar.buildAppbar(context,
          "${widget.edit == true ? "Update Category" : "Create Category"} "),
      body: BlocListener<CatBloc, CatState>(
        listener: (context, state) {
          if (state is Categoryfailed) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Category creation failed"),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.white70,
                ),
              );
          }
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
                                widget.edit == true ? widget.cat.name : "",
                            decoration: const InputDecoration(
                              hintText: 'eg:- model',
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter category name';
                              }
                              return null;
                            },
                            onChanged: (value) => this._cat['name'] = value
                            //  double.parse(value),
                            ),
                      ),
                    ),
                  
                    SizedBox(
                      height: 20.0,
                    ),
                    Stack(children: <Widget>[
                      if (widget.edit != true)
                        Container(
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
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
                                        "${baseURL}/api/${widget.cat.photo}",
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  )
                                // Image.network("${baseURL}/api/${widget.cat.photo}"
                                //     )
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
                    ]),

                    SizedBox(
                      height: 40.0,
                    ),
                    DefaultButton(
                      text: "submit",
                      
                      press: () {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();

                          final CatEvent event = widget.edit == true
                              ? _image == null
                                  ? CategoryUpdate(
                                      Category(
                                        id: widget.cat.id,
                                        name: this._cat["name"] == null
                                            ? widget.cat.name
                                            : this._cat["name"],
                                      ),
                                    )
                                  : CategoryImageUpdate(
                                      Category(
                                          id: widget.cat.id,
                                          name: this._cat["name"] == null
                                              ? widget.cat.name
                                              : this._cat["name"]),
                                      _image)
                              : CategroyCreate(
                                  Category(
                                    name: this._cat["name"],
                                  ),
                                  _image);
                          BlocProvider.of<CatBloc>(context).add(event);
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
                                builder: (context) => ShowCategory(),
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

  Widget bottomsheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Text(
            "choose picture for category",
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
