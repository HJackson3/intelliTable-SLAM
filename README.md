# intelliTable-SLAM

## Introduction

The code is currently set up to work for pre-recorded footage.

The footage should be in the following structure:
* `image` containing the image (these should be 640x480 but can be changed by editing userData.m)
* `time` containing the time (obtained from datetime()) that the corresponding image was taken at.

The toolbox can also be easily converted to work with real-time images on a robot (this is the main purpose of the code).
To do this change the Robot variable in userData.m as shown here:

```matlab
Robot{1} = struct(...                      % CONSTANT VELOCITY EXAMPLE
  ...
  'camera',             'footage');             % Type of camera - none, footage or robot
```
```matlab
Robot{1} = struct(...                      % CONSTANT VELOCITY EXAMPLE
  ...
  'camera',             'robot');             % Type of camera - none, footage or robot
```
It is worth noting that the Robotics Systems Toolbox for MATLAB is required to do this - along with the image acquisition toolbox, due to the use of ipcam() and ROS.

## Acknowledgement

The toolbox makes use of Joan Solà's toolbox, the original of which is available on github [here] (https://github.com/joansola/slamtb) and the website [here] (http://www.iri.upc.edu/people/jsola/JoanSola/eng/toolbox.html).
