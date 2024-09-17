import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for input formatters
import 'package:adjustment_app/calculation_ffi.dart'; // FFI calculation

void main()  {
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(1200, 750);
    const minSize = Size(1100, 650);
    appWindow.minSize = minSize;
    appWindow.size = initialSize; //default size
    appWindow.show();
  });
}

Color sage = Color.fromARGB(255, 59, 59, 59);
Color dark = Color.fromARGB(255, 149, 149, 149);
// First is degrees, next is radians
final List<bool> selectedAngle = <bool>[true, false];

String left = "Values will be displayed here.";
String right = "";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme myScheme = ColorScheme.fromSeed(
      seedColor: sage,
      brightness: Brightness.light,
    );

    ThemeData myTheme = ThemeData.light().copyWith(
      colorScheme: myScheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sage, // Change button color here
        ),
      ),
    );

    return MaterialApp(
      theme: myTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Text controllers for the input fields
  TextEditingController rot = TextEditingController();
  TextEditingController theta = TextEditingController();
  TextEditingController phi = TextEditingController();

  TextEditingController fRot = TextEditingController();
  TextEditingController fTheta = TextEditingController();
  TextEditingController fPhi = TextEditingController();

  TextEditingController xDist = TextEditingController();
  TextEditingController yDist = TextEditingController();
  TextEditingController zDist = TextEditingController();

  // Create an instance of the FFI Calculation class
  final Calculation _calculation = Calculation();

  // Input formatter to allow negative numbers and decimals
  final List<TextInputFormatter> _inputFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),  // Regex to allow negative numbers and decimal points
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Motor Adjustment App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w800
          ),
        ),
        toolbarHeight: 80,
        backgroundColor: sage,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [dark, dark, dark, sage, sage]
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(width: screenWidth),
              const Spacer(),
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < selectedAngle.length; i++) {
                      selectedAngle[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                selectedBorderColor: dark,
                selectedColor: Colors.white,
                fillColor: sage,
                color: Colors.black,
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: selectedAngle,
                children: const [
                  Text('Radians'),
                  Text('Degrees')
                ],
              ),
              const Spacer(),

              // Input fields for initial rotation, theta, phi
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth / 3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      padding: const EdgeInsets.all(7),
                      controller: rot,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 22
                      ),
                      placeholder: 'Initial Rotation (z)',
                      cursorColor: Colors.white,
                      inputFormatters: _inputFormatters,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                  SizedBox(width: screenWidth / 30),
                  SizedBox(
                    width: screenWidth / 3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      padding: const EdgeInsets.all(7),
                      controller: theta,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 22
                      ),
                      placeholder: 'Initial Theta (x)',
                      cursorColor: Colors.white,
                      inputFormatters: _inputFormatters,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                  SizedBox(width: screenWidth / 30),
                  SizedBox(
                    width: screenWidth / 3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      padding: const EdgeInsets.all(7),
                      controller: phi,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 22
                      ),
                      placeholder: 'Initial Phi (y)',
                      cursorColor: Colors.white,
                      inputFormatters: _inputFormatters,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Input fields for final rotation, theta, phi
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth / 3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      padding: const EdgeInsets.all(7),
                      controller: fRot,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 22
                      ),
                      placeholder: 'Final Rotation (z)',
                      cursorColor: Colors.white,
                      inputFormatters: _inputFormatters,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                  SizedBox(width: screenWidth / 30),
                  SizedBox(
                    width: screenWidth / 3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      padding: const EdgeInsets.all(7),
                      controller: fTheta,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 22
                      ),
                      placeholder: 'Final Theta (x)',
                      cursorColor: Colors.white,
                      inputFormatters: _inputFormatters,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                  SizedBox(width: screenWidth / 30),
                  SizedBox(
                    width: screenWidth / 3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      padding: const EdgeInsets.all(7),
                      controller: fPhi,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 22
                      ),
                      placeholder: 'Final Phi (y)',
                      cursorColor: Colors.white,
                      inputFormatters: _inputFormatters,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Input fields for x, y, z distance
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth / 3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      padding: const EdgeInsets.all(7),
                      controller: xDist,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 22
                      ),
                      placeholder: 'x-Axis Dist. from Origin (mm)',
                      cursorColor: Colors.white,
                      inputFormatters: _inputFormatters,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                  SizedBox(width: screenWidth / 30),
                  SizedBox(
                    width: screenWidth / 3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      padding: const EdgeInsets.all(7),
                      controller: yDist,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 22
                      ),
                      placeholder: 'y-Axis Dist. from Origin (mm)',
                      cursorColor: Colors.white,
                      inputFormatters: _inputFormatters,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                  SizedBox(width: screenWidth / 30),
                  SizedBox(
                    width: screenWidth / 3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      padding: const EdgeInsets.all(7),
                      controller: zDist,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 22
                      ),
                      placeholder: 'z-Axis Dist. from Origin (mm)',
                      cursorColor: Colors.white,
                      inputFormatters: _inputFormatters,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(52, 52, 52, 1),
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300),
                ),
                onPressed: () {
                  if (rot.text.isNotEmpty && phi.text.isNotEmpty && theta.text.isNotEmpty &&
                      xDist.text.isNotEmpty && yDist.text.isNotEmpty && zDist.text.isNotEmpty &&
                      fRot.text.isNotEmpty && fPhi.text.isNotEmpty && fTheta.text.isNotEmpty) {
                    setState(() {
                      // Convert text inputs to doubles
                      double r = double.parse(rot.text);
                      double p = double.parse(phi.text);
                      double t = double.parse(theta.text);
                      double dx = double.parse(xDist.text);
                      double dy = double.parse(yDist.text);
                      double dz = double.parse(zDist.text);
                      double fr = double.parse(fRot.text);
                      double fp = double.parse(fPhi.text);
                      double ft = double.parse(fTheta.text);

                      // Call the FFI-based calculation
                      String result = _calculation.calculate(r, p, t, dx, dy, dz, fr, fp, ft, selectedAngle[0]);

                      // Process the result and update the UI
                      List<String> output = result.split("\n\n");
                      left = output[0];
                      if (output.length > 1) {
                        right = output[1];
                      }
                    });
                  }
                }
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    left,
                    style: TextStyle(
                      fontSize: left == "Values will be displayed here." ? 50 : 16,
                      color: left == "Values will be displayed here." ? dark : Colors.white,
                    ),
                  ),
                  left == "Values will be displayed here." ? const SizedBox(width: 0) : const SizedBox(width: 100),
                  left != "Values will be displayed here." ? Text(
                    right,
                    style: TextStyle(
                      fontSize: left == "Values will be displayed here." ? 50 : 16,
                      color: left == "Values will be displayed here." ? dark : Colors.white,
                    ),
                  ) : const SizedBox(height: 0),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
