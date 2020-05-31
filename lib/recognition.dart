import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class RecognitionPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  static const route = '/recognition';

  RecognitionPage(this.cameras);

  @override
  _RecognitionPage createState() => new _RecognitionPage();
}

class _RecognitionPage extends State<RecognitionPage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model;

  @override
  void initState() {
    Tflite.close();
    _model = ModalRoute.of(context).settings.arguments;
    loadModel(); // TODO(panmari): This is async, so should be waited for.
    super.initState();
  }

  loadModel() async {
    String res;
    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
          numThreads: Platform.numberOfProcessors,
        );
        break;

      case mobilenet:
        res = await Tflite.loadModel(
          model: "assets/mobilenet_v1_1.0_224.tflite",
          labels: "assets/mobilenet_v1_1.0_224.txt",
          numThreads: Platform.numberOfProcessors,
        );
        break;

      case posenet:
        res = await Tflite.loadModel(
          model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
          numThreads: Platform.numberOfProcessors,
        );
        break;

      default:
        res = await Tflite.loadModel(
          model: "assets/ssd_mobilenet.tflite",
          labels: "assets/ssd_mobilenet.txt",
          numThreads: Platform.numberOfProcessors,
        );
    }
    print('Loaded model ' + res);
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detection using ' + _model),
      ),
      body: Stack(
        children: [
          Camera(
            widget.cameras,
            _model,
            setRecognitions,
          ),
          BndBox(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              _model),
        ],
      ),
    );
  }
}
