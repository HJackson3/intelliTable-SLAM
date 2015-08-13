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
clear
global MD PT % Mahalanobis distance and processing time

MD = fopen('mahalanobis.t','w');
PT = fopen('processing_time.t','w');

% Run the SLAM algorithm
slamtb;

% Stop the robot
for rob = [Rob.rob]
    if strcmp(Rob(rob).camera, 'robot')
        Rob(rob).youbot.Stop;
    end
end

% Save the map
st  = [Rob.state];  % All states for all robots
stX = [st.x];       % All states' xs for robots
save('last_loc.mat', 'Lmk', 'SimLmk', 'Obs', 'Map', 'stX');

% Close all files
fclose('all');

% Load the files used for post-processing
md = load('mahalanobis.t');
pt = load('processing_time.t');

% Compute the averages
ma = mean(md);
pr = mean(pt);

% Show the averages in the console
fprintf('Average mahalanobis distance:\t%s\n', ma);
fprintf('Average processing time:\t\t%s\n', pr);

% Show the figures for the individual values
figure(3);plot(pt);hold on
plot(1:numel(pt),pr*ones(size(pt)));title('Processing time.t');xlabel('Frame');ylabel('Time');hold off
figure(4);plot(md);hold on
plot(1:numel(md),ma*ones(size(md)));title('Mahalanobis distance squared.t');ylabel('Mahalanobis distance squared');hold off



