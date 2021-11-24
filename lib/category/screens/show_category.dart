import 'dart:io';
import 'package:appp/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ShowCategory extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _ShowCategoryState createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  String catimage;
  String catname;
  var catss;
  File _image;
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
    // ignore: close_sinks
    final catBloc = BlocProvider.of<CatBloc>(context);
    return Scaffold(
        key: widget._scaffoldKey,
        appBar: MyAppBar.buildAppbar(context, "all Categories"),
        body: BlocListener<CatBloc, CatState>(
          listener: (context, state) {},
          child: BlocBuilder<CatBloc, CatState>(builder: (context, state) {
            if (state is CategoryOperationFailure) {
              return TryAgain();
            }

            if (!(state is CategoryLoadSuccess)) {
              catBloc.add(CategoryLoad());
            }

            if (state is CategoryLoadSuccess) {
              final cats = state.cats;
              return cats.isEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 150),
                      child: Center(
                          child: Text(
                        "No Record Yet, Start Creating!",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        maxLines: 2,
                      )))
                  : ListView.builder(
                      itemCount: cats.length,
                      itemBuilder: (_, idx) {
                        return GestureDetector(
                            onTap: () => {},
                            child: Card(
                                elevation: 2,
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: [
                                                ProfileImagee(
                                                  image:
                                                      "${baseURL}/api/${cats[idx].photo}",
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  cats[idx].name,
                                                  style:
                                                      TextStyle(fontSize: 16.0),
                                                ),
                                                Spacer(),
                                                IconButton(
                                                    icon: Icon(Icons.update),
                                                    onPressed: () {
                                                      bool edit = true;
                                                      //setState(() {
                                                      catname = cats[idx].name;
                                                      catimage =
                                                          cats[idx].photo;
                                                      // });
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CreateCategory(
                                                                      scafoldkey:
                                                                          widget
                                                                              ._scaffoldKey,
                                                                      edit:
                                                                          edit,
                                                                      cat: cats[
                                                                          idx])));
                                                    }),
                                                IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      String issueid =
                                                          cats[idx].id;
                                                      catss = cats[idx].id;

                                                      _showAlertDialog(context);
                                                    }),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                        ]))));
                      });
            } else {
              return Container(
                child: CircularIndicat(),
              );
            }
          }),
        ));
  }

  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        // context.read<CatBloc>().add(
        //     CategoryDelete(cats[idx].id));

        BlocProvider.of<CatBloc>(context).add(CategoryDelete(catss));
        Navigator.pop(context);
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: Duration(seconds: 15),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("deleting..."),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                ],
              ),
              backgroundColor: Theme.of(context).shadowColor,
            ),
          );

        final eventBloc = BlocProvider.of<EventBloc>(context);
        // if (eventBloc != null && !(eventBloc.state is EventLoadSuccess))
        eventBloc.add(EventLoad("false"));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Conformation"),
      content: Text("would you like to delete this category?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
