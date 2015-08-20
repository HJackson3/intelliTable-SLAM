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

% Run Joan's edited SLAM algorithm
slamtb;

% Stop the robot
for rob = [Rob.rob]
    if strcmp(Rob(rob).camera, 'robot')
        Rob(rob).youbot.Stop;
        % Save the map
%         st  = [Rob.state];  % All states for all robots
%         stX = [st.x];       % All states' xs for robots
%         save('last_loc.mat', 'Lmk', 'SimLmk', 'Obs', 'Map', 'stX');
    end
end





