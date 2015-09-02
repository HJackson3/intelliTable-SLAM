# intelliTable-SLAM

## Introduction

This toolbox is a monocular EKF-based SLAM algorithm for the intelliTable robot, currently implemented on a KUKA youBot. Basically, it is a continuation of [Joan Sola's toolbox] (https://github.com/joansola/slamtb) to implement an [active-search algorithm] (http://homepages.laas.fr/monin/Version_anglaise/Publications_files/SLAM-MOT.pdf). The system is designed to run in real-time, but there is a base of work done for providing pre-recorded footage as well.

## Set-up

#### Quick set-up with an ipcam on the youBot

The system is currently designed for use with a KUKA youBot. only a couple of small changed are required:
- The renaming of the youBot itself in __createRobots.m__ on line 140.
- Setting the url of the ipcam __url__ in the Sensor object in __userData.m__.

#### Quick set-up with a simulated camera

As Joan Sola's toolbox was originally designed for use with a simulated camera and robot, set-up for reimplementing this is quite simple.

- __sim__ in the Sensor object needs changing from 'false' to 'true'.
- The value of __points__ in the World object needs setting up. For this reason, the original value has been left behind.
So,
```matlab
% Simulated world
%   - Simulation landmark sets, playground dimensions
World = struct(...
  'points',           [],... % For real image 
  ...'points',           thickCloister(-6,6,-6,6,1,7),... % For simulation
  'segments',         []);  % 3D segments - see HOUSE. 
```
Becomes,
```matlab
% Simulated world
%   - Simulation landmark sets, playground dimensions
World = struct(...
  ...'points',           [],... % For real image 
  'points',           thickCloister(-6,6,-6,6,1,7),... % For simulation
  'segments',         []);  % 3D segments - see HOUSE. 
```

#### Using pre-recorded footage

Some work still needs to be done to improve the algorithm for use with pre-recorded footage, though it is currently possible.

## New models

Sola lays out how models can be added very nicely in [__slamToolbox.pdf__] (http://www.iri.upc.edu/people/jsola/JoanSola/objectes/toolbox/slamToolbox.pdf).

Some models have been added as part of this implementation, most notably in __makeCamera.m__ for camera models and __createRobots.m__ for robot-specific information and robot components (such as arms, sensors, etc.) models.

## Improvements to the intelliTable-SLAM toolbox

Although the SLAM is largely complete, a number of improvements can be made to the system to improve usability or robustness:
- [ ] Improve the system for pre-recorded footage.
- [ ] Update the SLAM toolbox to integrate it with Joan Sola's updated SLAM algorithm.

## Acknowledgement

The toolbox makes use of Joan Solà's toolbox, the original of which is available on github [here] (https://github.com/joansola/slamtb) and the website [here] (http://www.iri.upc.edu/people/jsola/JoanSola/eng/toolbox.html).

Also included in the toolbox is omcaree's [youBot_MATLAB] (https://github.com/omcaree/youBot_MATLAB). This is used for interfacing with the youBot robot.