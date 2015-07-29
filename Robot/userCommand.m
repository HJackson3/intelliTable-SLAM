function Rob = userCommand( Rob )
%USERCOMMAND Changes the velocity of the Youbot if the simBot changes.
%   The x and y velocity of the simBot as well as the z angular velocity
%   are used to reset the base velocity of the Youbot object attached to
%   the simulated bot.
%   
%   Rob - the robot object whose velocity needs changing

%% Read in velocities of simbot which are relevant to the Youbot
% This is the x and y velocities and the angular motion in the z axis.
vel = Rob.state.x(8:9);
angVel = Rob.state.x(13);

%% Set the velocity of the robot to its new velocity
Rob.youbot.BaseVelocity(vel(1),vel(2),angVel);

%% Set the old Velocity to the current
Rob.state.oldV = Rob.state.x(8:13);

end