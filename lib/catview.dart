import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CatViewPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  static const route = '/catview';

  CatViewPage(this.cameras);

  @override
  _CatViewState createState() => new _CatViewState();
}

class _CatViewState extends State<CatViewPage> with WidgetsBindingObserver {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    initCam();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        initCam();
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  void initCam() {
    controller?.dispose();

    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container(child: Center(child: Text("Camera not available")));
    }
    // Use a smarter transformation, e.g. from
    // https://ixora.io/projects/colorblindness/color-blindness-simulation-research/
    const ColorFilter catmatrix = ColorFilter.matrix(<double>[
      0,  .5,  .5,  0,  0,
      0,  1,  0,  0,  0,
      0,  0,  1,  0,  0,
      0,  0,  0,  1,  0,
    ]);
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: catmatrix,
            child: CameraPreview(controller),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
