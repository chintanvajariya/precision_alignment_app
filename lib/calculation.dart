import 'dart:math';
import 'package:flutter/material.dart';

String calculation(double r, double p, double t, double dx, double dy, double dz) {
  
  // Calculate
  vm.Matrix3 Rs = rot(r, p, t);
  vm.Matrix3 Rf = rot(0, 0, 0); // Final desired orientation

  List<double> output = motorAngles(Rf, Rs);

  String result = 'R1 setting: ${output[1] * 180 / math.pi} degrees\n'
      'Azimuthal setting: ${-output[0] / (2 * math.pi)} rotations\n'
      'Tilt setting: ${output[2] / (2 * math.pi)} rotations\n';

  vm.Vector3 D = vm.Vector3(dx, dy, dz);
  vm.Vector3 Offset = rot(output[0], output[1], output[2]).transform(D);

  result += '\nX adjustment: ${-1 / math.sqrt(2) * (Offset.x - Offset.z)} mm\n'
      'Y adjustment: ${1 / math.sqrt(2) * (Offset.x + Offset.z)} mm\n'
      'Z adjustment: ${-Offset.y} mm';

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