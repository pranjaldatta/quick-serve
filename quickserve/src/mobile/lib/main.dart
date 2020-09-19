import 'package:flutter/material.dart';

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
              onPressed: () => {},
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(32, 36, 42, 1),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Color.fromRGBO(254, 211, 44, 1),
              onPressed: () {},
              child: Icon(
                Icons.photo_camera,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Color.fromRGBO(254, 211, 44, 1),
              onPressed: () {},
              child: Icon(
                Icons.image,
                color: Colors.black,
              ),
            ),
          ],
        )));
  }
}
