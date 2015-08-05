%  ROBSLAM The executed script to run the framework as a whole.
% 
%  This is the script unifiying the EKF-SLAM algorithm from slamtb and the
%  robot interface which movesthe robot around the map.
%  
%  This script calls slamtb from Joan Sola's EKF-SLAM algorithm
%  (http://www.iri.upc.edu/people/jsola/JoanSola/eng/toolbox.html) and uses
%  his SLAM algorithm, with updates for real-time footage from a
%  non-simulated robot, to build a map of the robot's environment.

global MD PT % Mahalanobis distance and processing time

MD = fopen('mahalanobis','w');
PT = fopen('processing_time','w');

slamtb;

fclose('all');

% Load the files used for post-processing
md = load('mahalanobis');
pt = load('processing_time');

fprintf('Average mahalanobis distance:\t%s\n', mean(md));
fprintf('Average processing time:\t\t%s\n', mean(pt));
figure(3);plot(pt);title('Processing time');xlabel('Frame');ylabel('Time');
figure(4);plot(md);title('Mahalanobis distance squared');ylabel('Mahalanobis distance squared');