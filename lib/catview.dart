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

    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
    );

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
    const ColorFilter catmatrix = ColorFilter.matrix([
      -1.0900984368899098,
      2.2175199905891096,
      -0.12737296039724047,
      0.0,
      0.0,
      -1.0342475886571665,
      2.0972998489516126,
      -0.06302821637306061,
      0.0,
      0.0,
      -0.1181700393438417,
      0.12537419873513828,
      0.9927985764733144,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      // 2.9474290199816493,
      // -1.6519622609956397,
      // 0.060369774527889754,
      // 0.0,
      // 0.0,
      // 3.485129226894302,
      // -1.9563603638919844,
      // 0.10803805848624833,
      // 0.0,
      // 0.0,
      // 0.28811068673581236,
      // -0.2443981226866301,
      // 1.0089313457675153,
      // 0.0,
      // 0.0,
      // 0.0,
      // 0.0,
      // 0.0,
      // 1.0,
      // 0.0
    ]);
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.linearToSrgbGamma(),
            child: ColorFiltered(
              colorFilter: catmatrix,
              child: ColorFiltered(
                colorFilter: ColorFilter.srgbToLinearGamma(),
                child: CameraPreview(controller),
              ),
            ),
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
