# Motor Adjustment App

## Purpose
There are dozens of places in our 2e- ARPES system that could be misaligned. We have set up alignment systems for the ultraviolet rays and their harmonic generation, the time-of-flight sensors, the data collection, and much more. However, none of these calibrations will provide consistent results if our superconductor is placed and angled erroneously in the chamber.

As such, this app uses Dart to wrap a custom motor angle and position calculator initially written in Python, which I rewrote in C++, to ensure these values can be adjusted before every trial. Before this app, these calculations would take a few minutes to compute by hand, as running the Python code was too unknown for some researchers. After the GUI's introduction, the calculator's use and efficiency have increased tenfold.

## Implementation
The conversion from Python to C++ was simpler than expected, as I understood the logic behind the calculator quite well. I did, however, need to build several default Python matrix functions from scratch in C++, which was somewhat complex. Implementing this converted calculator in my app was assisted by Flutter's FFI, or Foreign Function Interface, library, which allows me to feed inputs into C/C++ functions and gather their outputs. I then made use of these functions in my main.dart class, building the GUI in tandem.

## Preview
<img width="500" alt="empty_app" src="https://github.com/user-attachments/assets/56d8542c-cfcb-4897-a133-e7b1c86d2e33">

<img width="500" alt="radian input" src="https://github.com/user-attachments/assets/b7a3c383-04be-4ddd-9bf6-99ccb6125bb7">

<img width="500" alt="degree input" src="https://github.com/user-attachments/assets/30799cfd-406b-49eb-ae1d-d8bd39b2dadf">

## Read More About 2e- ARPES Setup
https://www.sciencedirect.com/science/article/pii/S0368204823001342
