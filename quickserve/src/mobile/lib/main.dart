import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() => runApp(MaterialApp(
      routes: {
        'upload': (context) => Upload(),
      },
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 36, 42, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "QuickServe",
                style: TextStyle(
                    color: Colors.white, fontSize: 50.0, fontFamily: "Roboto"),
              ),
            ),
            SizedBox(height: 20),
            Container(
                alignment: Alignment(0.5, 0),
                child: Image(
                  image: AssetImage("assets/girl.png"),
                ),
                width: 400,
                height: 400),
            Container(
              child: Text(
                "Hello There!",
                style: TextStyle(
                    color: Color.fromRGBO(254, 211, 44, 1),
                    fontSize: 30.0,
                    fontFamily: "Roboto"),
              ),
            ),
            SizedBox(height: 40),
            new RaisedButton(
              onPressed: () => Navigator.pushNamed(context, 'upload'),
              color: Color.fromRGBO(254, 211, 44, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(color: Color.fromRGBO(212, 171, 13, 1))),
              padding: const EdgeInsets.fromLTRB(80, 15, 80, 15),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(32, 36, 42, 1),
        body: _loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image == null
                        ? Container(
                            child: Text(
                              'Choose or Capture an Image',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(254, 211, 44, 1),
                                  fontSize: 50.0,
                                  fontFamily: "Roboto"),
                            ),
                          )
                        : Image.file(_image),
                    SizedBox(
                      height: 20,
                    ),
                    _outputs != null
                        ? Text(
                            "Prediction: ${_outputs[0]["label"]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Color.fromRGBO(254, 211, 44, 1),
              onPressed: pickImageCam,
              child: Icon(
                Icons.photo_camera,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Color.fromRGBO(254, 211, 44, 1),
              onPressed: pickImage,
              child: Icon(
                Icons.image,
                color: Colors.black,
              ),
            ),
          ],
        ));
  }

  pickImageCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.2,
      imageMean: 0,
      imageStd: 255.0,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
