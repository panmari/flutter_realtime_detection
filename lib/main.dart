import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home.dart';
import 'camera.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
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
        HomePage.route: (context) => HomePage(cameras),
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      home: HomePage(cameras),
    );
  }
}
