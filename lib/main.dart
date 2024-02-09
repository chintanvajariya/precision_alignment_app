import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main()  {
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(1110, 650);
    const minSize = Size(1100, 500);
    appWindow.minSize = minSize;
    appWindow.size = initialSize; //default size
    appWindow.show();
  });
}

Color sage = Color.fromARGB(255, 24, 187, 119);
Color dark = Color.fromARGB(255, 98, 148, 255);
//first is degrees, next is radians
final List<bool> selectedAngle = <bool>[true, false];

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    ColorScheme myScheme = ColorScheme.fromSeed(
      seedColor: sage,
      brightness: Brightness.light,
    );

    ThemeData myTheme = ThemeData.light().copyWith(colorScheme: myScheme);

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
  List<Widget> angles = <Widget>[
    const Text('Degrees'),
    const Text('Radians')
  ];


  TextEditingController inputControllerXRot = TextEditingController();
  TextEditingController inputControllerYRot = TextEditingController();
  TextEditingController inputControllerZRot = TextEditingController();


  TextEditingController inputControllerXDist = TextEditingController();
  TextEditingController inputControllerYDist = TextEditingController();
  TextEditingController inputControllerZDist = TextEditingController();


  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
        backgroundColor: dark,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [dark, sage]
            ),
        ),
        child:  Center(
          child: Column(
            children: [
              SizedBox(width: screenWidth, height: 20),
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < selectedAngle.length; i++) {
                      selectedAngle[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: dark,
                selectedColor: Colors.white,
                fillColor: sage.withGreen(175),
                color: Colors.black,
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: selectedAngle,
                children: angles,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth/3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                      padding: const EdgeInsets.only(right: 7, top: 7, bottom: 7,),
                      controller: inputControllerXRot,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: 22),
                      placeholder: 'x-Axis Rotation',
                      cursorColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: screenWidth/30),
                  SizedBox(
                    width: screenWidth/3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                      padding: const EdgeInsets.only(right: 7, top: 7, bottom: 7,),
                      controller: inputControllerYRot,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: 22),
                      placeholder: 'y-Axis Rotation',
                      cursorColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: screenWidth/30),
                  SizedBox(
                    width: screenWidth/3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                      padding: const EdgeInsets.only(right: 7, top: 7, bottom: 7,),
                      controller: inputControllerZRot,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: 22),
                      placeholder: 'z-Axis Rotation',
                      cursorColor: Colors.white,
                    ),
                  ),
                ],
              ),


              SizedBox(width: screenWidth, height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth/3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                      padding: const EdgeInsets.only(right: 7, top: 7, bottom: 7,),
                      controller: inputControllerXDist,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: 22),
                      placeholder: 'x-Axis Dist. from Origin (mm)',
                      cursorColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: screenWidth/30),
                  SizedBox(
                    width: screenWidth/3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                      padding: const EdgeInsets.only(right: 7, top: 7, bottom: 7,),
                      controller: inputControllerYDist,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: 22),
                      placeholder: 'y-Axis Dist. from Origin (mm)',
                      cursorColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: screenWidth/30),
                  SizedBox(
                    width: screenWidth/3.5,
                    child: CupertinoTextFormFieldRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(1, 1, 1, 0.075),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                      padding: const EdgeInsets.only(right: 7, top: 7, bottom: 7,),
                      controller: inputControllerZDist,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontSize: 22),
                      placeholder: 'z-Axis Dist. from Origin (mm)',
                      cursorColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      )
    );
  }
}