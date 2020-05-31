import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'catview.dart';
import 'home.dart';
import 'recognition.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tflite real-time detection',
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (context) => HomePage(),
        RecognitionPage.route: (context) => RecognitionPage(cameras),
        CatViewPage.route: (context) => CatViewPage(cameras),
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}
