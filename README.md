# Motor Adjustment App

## Purpose
There are dozens of places in our 2e- ARPES system that could be misaligned. We have set up alignment systems for the ultraviolet rays and their harmonic generation, the time-of-flight sensors, the data collection, and much more. However, none of these calibrations will provide consistent results if our superconductor is placed and angled erroneously in the chamber.

As such, this app uses Dart to wrap a custom motor angle and position calculator initially written in Python, which I rewrote in C++, to ensure these values can be adjusted before every trial. Before this app, these calculations would take a few minutes to compute by hand, as running the Python code was too unknown for some researchers. After the GUI's introduction, the calculator's use and efficiency have increased tenfold.

## Preview
<img width="500" alt="empty_app" src="https://github.com/user-attachments/assets/56d8542c-cfcb-4897-a133-e7b1c86d2e33">

<img width="500" alt="radian input" src="https://github.com/user-attachments/assets/bfed3125-e90a-4932-950e-9e2522a40a52">

<img width="500" alt="degree input" src="https://github.com/user-attachments/assets/7c9545c6-7353-4813-9902-5bc141a41da6">

## Read More About 2e- ARPES Setup
https://www.sciencedirect.com/science/article/pii/S0368204823001342
