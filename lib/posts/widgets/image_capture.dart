import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  ImageCapture({this.imageFile}) {}
  final List<File> imageFile;
  createState() => _ImageCaptureState(imageFile: this.imageFile);
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  _ImageCaptureState({this.imageFile}) {}
  final List<File> imageFile;
  int imageCount = 0;

  /// Cropper plugin
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
      this.imageFile[this.imageFile.indexOf(imageFile)] = cropped ?? imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    if (selected == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No image is selected"),
      ));
      return;
    }
    setState(() {
      this.imageFile.add(selected);
      this.imageCount = this.imageFile.length;
      _cropImage(selected);
    });
  }

  /// Remove image
  void _clear() {
    setState(() {
      this.imageFile.clear();
      this.imageCount = this.imageFile.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: this
                    .imageFile
                    .map(
                      (e) => Container(
                        margin: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12)),
                        child: Column(
                          children: [
                            Container(width: 60.0, child: Image.file(e)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon:
                                        Icon(Icons.edit, color: Colors.black45),
                                    onPressed: () {
                                      _cropImage(e);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.black45),
                                    onPressed: () {
                                      setState(() {
                                        this.imageFile.remove(e);
                                        this.imageCount = this.imageFile.length;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          (this.imageCount <= 2)
              ? Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.photo_camera, color: Colors.black45),
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon:
                              Icon(Icons.photo_library, color: Colors.black45),
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),
                )
              : Text("Maximum 3 pictures allowed"),
        ],
      ),
    );
  }

  Column _imageTumb(imageFile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: (imageFile != null)
          ? <Widget>[
              Container(
                child: Image.file(imageFile),
                width: 70.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      child: Icon(Icons.crop),
                      onPressed: () => _cropImage(imageFile),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Icon(Icons.refresh),
                      onPressed: _clear,
                    ),
                  ),
                ],
              ),
              //  Uploader(file: imageFile)
            ]
          : [],
    );
  }
}
