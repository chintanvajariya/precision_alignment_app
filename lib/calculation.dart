import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vm;

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

vm.Matrix3 rot(double r, double p, double t) {
  vm.Matrix3 Rr = vm.Matrix3.rotationZ(r);
  vm.Matrix3 Rp = vm.Matrix3.rotationY(p);
  vm.Matrix3 Rt = vm.Matrix3.rotationX(t);

  // Combine rotations
  return Rp * Rt * Rr;
}

List<double> motorAngles(vm.Matrix3 Rf, vm.Matrix3 Rs) {
  vm.Matrix3 Rm = Rf * Rs.invert();

  double theta = -math.asin(Rm.entry(1, 2));
  double phi = math.asin(Rm.entry(0, 2) / math.cos(theta));
  double rotation = math.asin(Rm.entry(1, 0) / math.cos(theta));

  return [rotation, phi, theta];
}