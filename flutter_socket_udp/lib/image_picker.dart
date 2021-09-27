import 'dart:io';

import 'package:flutter/material.dart';

import 'plugins/image_picker/image_picker_widget.dart';

class ImagePicker extends StatefulWidget {
  ImagePicker({Key? key}) : super(key: key);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  String? _filePath;
  Widget? _imageBox;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("ImagePicker"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            ImagePickerWidget(
              diameter: 180,
              initialImage: Image.asset("assets/2.jpg").image,
              shape: ImagePickerWidgetShape.square,
              isEditable: true,
              onChange: (File file) {
                _filePath = file.path;
                _loadImageFile();
                print("I changed the file to: $_filePath");
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                  color: Colors.grey.shade500,
                  width: screenSize.width * 0.9,
                  height: screenSize.height * 0.2,
                  alignment: Alignment.center,
                  child: _imageBox ?? Text("select image")),
            ),
          ]),
        ),
      ),
    );
  }

  void _loadImageFile() async {
    File file = File(_filePath ?? "");
    file.exists().then((value) {
      if (value) {
        setState(() {
          _imageBox = Image.file(file);
        });
      }
    });
  }
}
