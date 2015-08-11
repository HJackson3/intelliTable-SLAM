function Rob = robReadLidar( Rob, Opt )
%   ROBREADLIDAR Reads the lidar data on the Youbot and changes the velocity
%   accordgingly
%   
%   This function is designed to prevent the robot from colliding with
%   objects whilst still navigating through its environment.
% 

global Map

%% Query the Lidar
lData       = receive(Rob.lidar); % Read in the data from the Lidar
view        = lData.Ranges(256-Opt.lidar.scanWidth:256+Opt.lidar.scanWidth);

%% Set the new velocities if necessary 
mFront      = min(view(isfinite(view)));
newV1       = Rob.state.origV(1);
newAng      = Rob.state.origV(6);

switch Opt.lidar.version
    case 'optDist'
        if ~isempty(mFront)
            newV1 = (mFront - Opt.lidar.minDist)/10;
        end
    case 'quickstop'
        if ~isempty(mFront)
            if mFront < Opt.lidar.minDist
                newV1 = 0;
            end
        end
    case 'turnOnSpot'
        if ~isempty(mFront)
            if mFront < Opt.lidar.minDist
                newV1   = 0;
                newAng  = deg2rad(Opt.lidar.searchAngV);
            end
        end        
end

if newV1 > 1 || ~isfinite(newV1)
    newV1 = Rob.state.origV(1);
end

%% Set new velocity

[r1, ~, ~] = quat2angle(Rob.state.x(4:7)');

newV1 = newV1*cos(r1);
newV2 = newV1*sin(r1);

Rob.state.x(8:9)  = [newV1,newV2];          % Sets new x-velocity
Rob.state.x(13)   = newAng;                 % Sets new z-angular velocity

% create vector to alter con.
newVal          = zeros(size(Rob.con.u));
newVal(1:2)     = Rob.state.x(8:9);
newVal(6)       = Rob.state.x(13);

Rob.con.u       = newVal - Rob.con.oldU;  % Sets new con
Rob.con.oldU    = Rob.con.u;              % Old con reset

Map.x(Rob.state.r)     = Rob.state.x;

end

