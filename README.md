# intelliTable-SLAM

The code is currently set up to work for pre-recorded footage.

The footage should be in the following structure:
* `image` containing the image ( these should be 640x480 but can be changed by editing userData.m)
* `time` containing the time (obtained from datetime()) that the corresponding image was taken at.

The toolbox can also be easily converted to work with real-time images (this is the main purpose of the code). To do this, change the robot's `camera` to `robot` from `footage`.
