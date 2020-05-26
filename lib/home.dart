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

  Widget _buildModelSelectButton(String model) {
    return RaisedButton(
              child: Text(model),
              onPressed: () =>
                  Navigator.pushNamed(context, RecognitionPage.route, arguments: model),
            );
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
            _buildModelSelectButton(ssd),
            _buildModelSelectButton(yolo),
            _buildModelSelectButton(mobilenet),
            _buildModelSelectButton(posenet),
          ],
        ),
      ),
    );
  }
}
