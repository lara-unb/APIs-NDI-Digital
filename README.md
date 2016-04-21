# APIs-NDI-Digital

This repository contains the necessary libraries for using both the Polaris optical and Aurora electromagnetic tracking systems, from NDI Medical, in Matlab. Both devices use the PortHandle.m file, but otherwise, Aurora and Polaris files are independent. 

The setup files connects to its respective device and generates a beep sound for testing of communication ports, and doubles as an example for the general connection commands to be used in coding. There is also another script, polaris_exit_debug.m,  for stopping the Polaris device execution, in case a program is interrupted and the device keeps running. They use libraries from DQ Robotics, which are not necessary for using just the NDI equipment, but are convenient in any case. They can be obtained at http://dqrobotics.sourceforge.net/ complete with installation instructions.

DQ Robotics is an open-source (LGPLv3) standalone open-source Robotics library, by Bruno Vilhena Adorno and Murilo Marques Marinho. It provides dual quaternion algebra, kinematic calculation algorithms in Python, MATLAB and C++ that can be applied in robot control. The library has a catkin package wrapper for use in ROS Indigo, and also provides a V-REP interface.
