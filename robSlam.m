%  ROBSLAM The executed script to run the framework as a whole.
% 
%  This is the script unifiying the EKF-SLAM algorithm from slamtb and the
%  robot interface which movesthe robot around the map.
%  
%  This script calls slamtb from Joan Sola's EKF-SLAM algorithm
%  (http://www.iri.upc.edu/people/jsola/JoanSola/eng/toolbox.html) and uses
%  his SLAM algorithm, with updates for real-time footage from a
%  non-simulated robot, to build a map of the robot's environment.

slamtb;