%  ROBSLAM The executed script to run the framework as a whole.
% 
%  This is the script unifiying the EKF-SLAM algorithm from slamtb and the
%  robot interface which moves the robot around the map, as well as the
%  analysis for testing.
%  
%  This script calls slamtb from Joan Sola's EKF-SLAM algorithm
%  (http://www.iri.upc.edu/people/jsola/JoanSola/eng/toolbox.html) and uses
%  his SLAM algorithm, with updates for real-time footage from a
%  non-simulated robot, to build a map of the robot's environment.

global MD PT % Mahalanobis distance and processing time

MD = fopen('mahalanobis','w');
PT = fopen('processing_time','w');

% Run the SLAM algorithm
slamtb;

fclose('all');

% Load the files used for post-processing
md = load('mahalanobis');
pt = load('processing_time');

% Compute the averages
ma = mean(md);
pr = mean(pt);

% Show the averages in the console
fprintf('Average mahalanobis distance:\t%s\n', ma);
fprintf('Average processing time:\t\t%s\n', pr);

% Show the figures for the individual values
figure(3);plot(pt);title('Processing time');xlabel('Frame');ylabel('Time');
figure(4);plot(md);title('Mahalanobis distance squared');ylabel('Mahalanobis distance squared');