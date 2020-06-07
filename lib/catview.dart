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
      -1.0900984368899098, 2.2175199905891096, -0.12737296039724047, 0.0, 0.0,
      -1.0342475886571665, 2.0972998489516126, -0.06302821637306061, 0.0, 0.0,
      -0.1181700393438417, 0.12537419873513828, 0.9927985764733144, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]);
    const ColorFilter catmatrix2 = ColorFilter.matrix([
      0.1705569959951633, 0.17055699434260266, -0.004517141844953037, 0.0, 0.0,
      0.8294430128562018, 0.8294430047054198, 0.00451713687057316, 0.0, 0.0,
      7.65392266233178e-9, 3.3440955282681983e-9, 0.9999999917887479, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]);
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.linearToSrgbGamma(),
            child: ColorFiltered(
              colorFilter: catmatrix2,
              child: ColorFiltered(
                colorFilter: ColorFilter.srgbToLinearGamma(),
                child: CameraPreview(controller),
              ),
            ),
          ),
          // BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          //   child: Container(
          //     color: Colors.transparent,
          //   ),
          // ),
        ],
      ),
    );
  }
}
