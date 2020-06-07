// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';

void main() {
  // Computes color filter matrix. Can not be done at runtime as color filter needs to be const.
  // https://ixora.io/projects/colorblindness/color-blindness-simulation-research/
  // See also https://github.com/hx2A/ColorBlindness/blob/master/src/colorblind/ColorUtilities.java
  // Note that the syntax is column-major order.
  var rgb2lms = Matrix4(
    0.31399022, 0.15537241, 0.01775239, 0,
    0.63951294, 0.75789446, 0.10944209, 0, 
    0.04649755, 0.08670142, 0.87256922, 0,
    0, 0, 0, 1).transposed();
  var protanopiaSim = Matrix4(
    0, 0, 0, 0,
    1.05118294, 1, 0, 0,
    -0.05116099, 0, 1, 0,
    0, 0, 0, 1).transposed();
  var lms2rgb = Matrix4(
    5.47221206, -1.1252419, 0.02980165, 0,
    -4.6419601, 2.29317094, -0.19318073, 0,
    0.16963708, -0.1678952, 1.16364789, 0,
    0, 0, 0, 1).transposed();


  var T = rgb2lms.multiplied(protanopiaSim).multiplied(lms2rgb);
  // For ColorFilter, the matrix needs to be row-major.
  // Taking the transpose here just does that.
  T.transpose();
  var output = "";
  for (var i = 0; i < 4*5; i++) {
    var row = i ~/ 5;
    var col = i % 5;
    if (col == 4) {
      output += "0.0,\n";
    } else {
      var idx = i - row;
      var v = T.storage[idx];
      output += "$v, ";
    }
  }
  print(output);
}
