function Rob = robReadLidar( Rob, Opt )
%   ROBREADLIDAR Reads the lidar data on the Youbot and changes the velocity
%   accordgingly
%   
%   This function is designed to prevent the robot from colliding with
%   objects whilst still navigating through its environment.
% 

%% Query the Lidar
lData       = receive(Rob.lidar); % Read in the data from the Lidar
view        = lData.Ranges(256-Opt.lidar.scanWidth:256+Opt.lidar.scanWidth);

%% Set the new velocities if necessary 
mFront      = min(view(isfinite(view)));
switch Opt.lidar.version
    case 'optDist'
        if ~isempty(mFront)
            newV1 = (mFront - Opt.lidar.minDist)/10;
        else
            newV1 = Rob.state.origV(1);
        end
    case 'quickstop'
        if ~isempty(mFront)
            if mFront < Opt.lidar.minDist
                newV1 = 0;
            else
                newV1 = Rob.state.origV(1);
            end
        else
            newV1 = Rob.state.origV(1);
        end
    case 'turnOnSpot'
        if ~isempty(mFront)
            if mFront < Opt.lidar.minDist
                newV1   = 0;
                newAng  = Opt.lidar.searchAngV;
            else
                newV1   = Rob.state.origV(1);
                newAng  = Rob.state.origV(6);
            end
        else
            newV1 = Rob.state.origV(1);
            newAng  = Rob.state.origV(6);
        end        
end

if newV1 > 1 || ~isfinite(newV1)
    newV1 = Rob.state.origV(1);
end

%% Set new velocity
figure(3);colorbar;imagesc(view);
Rob.state.x(8)  = newV1;
Rob.state.x(13) = newAng;

end

