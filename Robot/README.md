# /Robot

Contents
- `robChangeVel.m`
This file sets the velocity of the robot - currently specifically for a Youbot
- `robData.m`
This file is for robot-specific variable assignment to override EKF-SLAM/userData.m if you would like to put it in a more user-friendly location.
- `robReadLidar.m`
This file is designed to read and process the data from the Lidar mounted on the Youbot and is rather specific to the Youbot.

The current implementation is heavily oriented around use with a Youbot but it is possible to change them relatively easily to work with any other ROS robot, at the very least by replacing the functions entirely.
As long as the input and outputs of the functions are kept the same, this should have no affect on the functionality of the toolbox.
