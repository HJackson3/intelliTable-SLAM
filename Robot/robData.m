%  ROBDATA user inputted data for the real robot used in the SLAM
%  algorithm
%  
%  These variables are either new to the framework (ie. not from the
%  EKF-SLAM) or overwrite the userData input to make editing the
%  environment easier.

%% Set up the relevant variables (Robot, Camera, etc.).

% Robot variables - added to the existing Robot structure from
% EKF-SLAM\userData.m
Robot{1}.botType  = 'youbot'; % youbot used
Robot{1}.camera   = 'footage';  % Type of camera - none, footage or robot

% Pre-recorded sensor footage (if used).
% load('forwardsFacingRightOne.mat');
% load('forwardsFacingRightTwo.mat');
% load('forwardsFacingRightThree.mat');
% load('forwardsFacingRightFour.mat');
load('forwardsFacingRightFive.mat');
