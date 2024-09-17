import 'dart:ffi';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart';

typedef CalculateNative = Pointer<Utf8> Function(
  Double r_in, Double p_in, Double t_in,
  Double dx_in, Double dy_in, Double dz_in,
  Double fr_in, Double fp_in, Double ft_in, Int32 isRadian
);

typedef CalculateDart = Pointer<Utf8> Function(
  double r_in, double p_in, double t_in,
  double dx_in, double dy_in, double dz_in,
  double fr_in, double fp_in, double ft_in, int isRadian
);

class Calculation {
  late DynamicLibrary _calculationLib;
  late CalculateDart _calculate;

  Calculation() {
    String dylibPath;

    if (io.Platform.isMacOS) {
      final executableDir = path.dirname(io.Platform.resolvedExecutable);
      dylibPath = path.join(executableDir, '../Frameworks', 'libcalculation.dylib');
    } else {
      throw UnsupportedError('This platform is not supported.');
    }

    _calculationLib = DynamicLibrary.open(dylibPath);

    _calculate = _calculationLib
        .lookup<NativeFunction<CalculateNative>>('calculate')
        .asFunction();
  }

  String calculate(double r_in, double p_in, double t_in,
                   double dx_in, double dy_in, double dz_in,
                   double fr_in, double fp_in, double ft_in, bool isRadian) {
    return _calculate(r_in, p_in, t_in, dx_in, dy_in, dz_in, fr_in, fp_in, ft_in, isRadian ? 1 : 0)
        .toDartString();
  }
}