import 'package:flutter/material.dart';

import 'recognition.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';

  HomePage();

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select model'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text(ssd),
              //               Navigator.pushNamed(
              //   context,
              //   RunnerDetails.routeName,
              //   arguments: runner,
              // );
              // TODO(panmari): Pass arguments (model name).
              onPressed: () =>
                  Navigator.pushNamed(context, RecognitionPage.route),
            ),
            RaisedButton(
              child: const Text(yolo),
              onPressed: () =>
                  Navigator.pushNamed(context, RecognitionPage.route),
            ),
            RaisedButton(
              child: const Text(mobilenet),
              onPressed: () =>
                  Navigator.pushNamed(context, RecognitionPage.route),
            ),
            RaisedButton(
              child: const Text(posenet),
              onPressed: () =>
                  Navigator.pushNamed(context, RecognitionPage.route),
            ),
          ],
        ),
      ),
    );
  }
}
