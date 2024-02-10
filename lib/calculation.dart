import 'dart:math';
import 'package:flutter/material.dart';

List<List<double>> rot(double r, double p, double t) {
  List<List<double>> rr = [
    [cos(r), -sin(r), 0],
    [sin(r), cos(r), 0],
    [0, 0, 1]
  ];
  List<List<double>> rt = [
    [1, 0, 0],
    [0, cos(t), -sin(t)],
    [0, sin(t), cos(t)]
  ];
  List<List<double>> rp = [
    [cos(p), 0, sin(p)],
    [0, 1, 0],
    [-sin(p), 0, cos(p)]
  ];
  return matrixMultiply(matrixMultiply(rp, rt), rr);
}

List<double> motorAngles(List<List<double>> rf, List<List<double>> rs) {
  var rm = matrixMultiply(rf, matrixInverse(rs));
  var theta = -asin(rm[1][2]);
  var phi = asin(rm[0][2] / cos(theta));
  var rotation = asin(rm[1][0] / cos(theta));
  return [rotation, phi, theta];
}

List<List<double>> matrixMultiply(List<List<double>> a, List<List<double>> b) {
  var result = List.generate(a.length, (i) => List.filled(b[0].length, 0.0), growable: false);
  for (var i = 0; i < a.length; i++) {
    for (var j = 0; j < b[0].length; j++) {
      for (var k = 0; k < a[0].length; k++) {
        result[i][j] += a[i][k] * b[k][j];
      }
    }
  }
  return result;
}

List<double> matrixVectorMultiply(List<List<double>> matrix, List<double> vector) {
  assert(matrix.length == 3 && vector.length == 3);
  return List.generate(3, (i) => 
    matrix[i][0] * vector[0] + 
    matrix[i][1] * vector[1] + 
    matrix[i][2] * vector[2]);
}



List<List<double>> matrixInverse(List<List<double>> m) {
  // This function assumes the matrix is invertible and 3x3
  var det = m[0][0] * (m[1][1] * m[2][2] - m[2][1] * m[1][2]) -
            m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) +
            m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
  var invDet = 1 / det;
  return [
    [
      invDet * (m[1][1] * m[2][2] - m[2][1] * m[1][2]),
      invDet * (m[0][2] * m[2][1] - m[0][1] * m[2][2]),
      invDet * (m[0][1] * m[1][2] - m[0][2] * m[1][1])
    ],
    [
      invDet * (m[1][2] * m[2][0] - m[1][0] * m[2][2]),
      invDet * (m[0][0] * m[2][2] - m[0][2] * m[2][0]),
      invDet * (m[1][0] * m[0][2] - m[0][0] * m[1][2])
    ],
    [
      invDet * (m[1][0] * m[2][1] - m[2][0] * m[1][1]),
      invDet * (m[2][0] * m[0][1] - m[0][0] * m[2][1]),
      invDet * (m[0][0] * m[1][1] - m[1][0] * m[0][1])
    ]
  ];
}

List<String> calculate (TextEditingController r_in, TextEditingController p_in, TextEditingController t_in, 
                  TextEditingController dx_in, TextEditingController dy_in, TextEditingController dz_in, 
                  TextEditingController fr_in, TextEditingController fp_in, TextEditingController ft_in, bool isRadian) {
  double py_r = isRadian ? double.parse(r_in.text) : double.parse(r_in.text) * pi / 180;
  double py_t = isRadian ? double.parse(t_in.text) : double.parse(t_in.text) * pi / 180;
  double py_p = isRadian ? double.parse(p_in.text) : double.parse(p_in.text) * pi / 180;

  double dx = double.parse(dx_in.text);
  double dy = double.parse(dy_in.text);
  double dz = double.parse(dz_in.text);

  double f_r = isRadian ? double.parse(fr_in.text) : double.parse(fr_in.text) * pi / 180;
  double f_p = isRadian ? double.parse(fp_in.text) : double.parse(fp_in.text) * pi / 180;
  double f_t = isRadian ? double.parse(ft_in.text) : double.parse(ft_in.text) * pi / 180;

  var rs = rot(py_r, py_p, py_t);
  var rf = rot(f_r, f_p, f_t);
  var output = motorAngles(rf, rs);

  List<String> out = ["", ""];

  out[0] += 'R1 setting: ${output[1] * 180 / pi} degrees\n';
  out[0] += 'Azimuthal setting: ${-output[0] / (2 * pi)} rotations\n';
  out[0] += 'Tilt setting: ${output[2] / (2 * pi)} rotations';

  var R = rot(output[0], output[1], output[2]);
  var D = [dx, dy, dz];

  var offset = matrixVectorMultiply(R, D);

  out[1] += 'X adjustment: ${-1 / sqrt(2) * (offset[0] - offset[2])} mm\n';
  out[1] += 'Y adjustment: ${1 / sqrt(2) * (offset[0] + offset[2])} mm\n';
  out[1] += 'Z adjustment: ${-offset[1]} mm';

  return out;
}