// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_realtime_detection/main.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   expect(find.text('detection'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  // });

  // Note that the syntax is column-major order.
  var T = Matrix4(
    0.31399022, 0.15537241, 0.01775239, 0,
    0.63951294, 0.75789446, 0.10944209, 0, 
    0.04649755, 0.08670142, 0.87256922, 0,
    0, 0, 0, 1);
  var S = Matrix4(
    0, 0, 0, 0,
    1.05118294, 1, 0, 0,
    -0.05116099, 0, 1, 0,
    0, 0, 0, 1);
  var T_inv = Matrix4(
    5.47221206, -1.1252419, 0.02980165, 0,
    -4.6419601, 2.29317094, -0.19318073, 0,
    0.16963708, -0.1678952, 1.16364789, 0,
    0, 0, 0, 1);


  // Use a smarter transformation, e.g. from
  // https://ixora.io/projects/colorblindness/color-blindness-simulation-research/
  T.multiply(S);
  T.multiply(T_inv);
  // For ColorFilter, the matrix needs to be row-major.
  // Taking the transpose here just does that.
  T.transpose();
  for (var i = 0; i < 4*5; i++) {
    var row = i ~/ 5;
    var col = i % 5;
    if (col == 4) {
      print("0.0,");
    } else {
      var idx = i - row;
      var v = T.storage[idx];
      print("$v,");
    }
  }
}
