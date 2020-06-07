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
    0, 0, 0, 1);
  var protanopiaSim = Matrix4(
    0, 0, 0, 0,
    1.05118294, 1, 0, 0,
    -0.05116099, 0, 1, 0,
    0, 0, 0, 1);
  var lms2rgb = Matrix4(
    5.47221206, -1.1252419, 0.02980165, 0,
    -4.6419601, 2.29317094, -0.19318073, 0,
    0.16963708, -0.1678952, 1.16364789, 0,
    0, 0, 0, 1);

  var T = lms2rgb.multiplied(protanopiaSim).multiplied(rgb2lms);

  // Alternative matrices from https://arxiv.org/pdf/1711.10662.pdf
  var rgb2lmsExp = Matrix4(
   17.8824, 43.5161, 4.1194, 0,
    3.4557, 27.1554, 3.8671, 0,
    0.0300, 0.1843, 1.4671, 0,
    0, 0, 0, 1
  ).transposed();

  var protanopiaSimExp = Matrix4(
    0, 2.0234, -2.5258, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1).transposed();

  var lms2rgbExp = Matrix4(
    0.0809, -0.1305, 0.1167, 0,
    -0.0102, 0.0540, -0.1136, 0,
    -0.0004, -0.0041, 0.6935, 0,
    0, 0, 0, 1
  ).transposed();
  T = lms2rgbExp.multiplied(protanopiaSimExp).multiplied(rgb2lmsExp);
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
