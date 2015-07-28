% SLAMTB  An EKF-SLAM algorithm with simulator and graphics.
%
%   This script performs multi-robot, multi-sensor, multi-landmark 6DOF
%   EKF-SLAM with simulation and graphics capabilities.
%
%   Please read slamToolbox.pdf in the root directory thoroughly before
%   using this toolbox.
%
%   - Beginners should not modify this file, just edit USERDATA.M and enter
%   and/or modify the data you wish to simulate.
%
%   - More advanced users should be able to create new landmark models, new
%   initialization methods, and possibly extensions to multi-map SLAM. Good
%   luck!
%
%   - Expert users may want to add code for real-data experiments. 
%
%   See also USERDATA, USERDATAPNT, USERDATALIN.
%
%   Also consult slamToolbox.pdf in the root directory.

%   Created and maintained by
%   Copyright 2008, 2009, 2010 Joan Sola @ LAAS-CNRS.
%   Copyright 2011, 2012, 2013 Joan Sola.
%   Programmers (for parts of the toolbox):
%   Copyright David Marquez and Jean-Marie Codol @ LAAS-CNRS
%   Copyright Teresa Vidal-Calleja @ ACFR.
%   See COPYING.TXT for full copyright license.

%% OK we start here

% clear workspace and declare globals
clear
global Map    

%% I. Specify user-defined options - EDIT USER DATA FILE userData.m

userData;           % user-defined data. SCRIPT.
% userDataPnt;        % user-defined data for points. SCRIPT.
% userDataLin;        % user-defined data for lines. SCRIPT.

% One can insert their own script here to make changes to the userData or
% make new objects from a separate file.


%% II. Initialize all data structures from user-defined data in userData.m
% SLAM data
[Rob,Sen,Raw,Lmk,Obs,Tim]     = createSlamStructures(...
    Robot,...
    Sensor,...      % all user data
    Time,...
    Opt);

% Simulation data
[SimRob,SimSen,SimLmk,SimOpt] = createSimStructures(...
    Robot,...
    Sensor,...      % all user data
    World,...
    SimOpt);

% Graphics handles
[MapFig,SenFig]               = createGraphicsStructures(...
    Rob, Sen, Lmk, Obs,...      % SLAM data
    SimRob, SimSen, SimLmk,...  % Simulator data
    FigOpt);                    % User-defined graphic options


%% III. Initialize data logging
% TODO: Create source and/or destination files and paths for data input and
% logs.
% TODO: do something here to collect data for post-processing or
% plotting. Think about collecting data in files using fopen, fwrite,
% etc., instead of creating large Matlab variables for data logging.

% Clear user data - not needed anymore
clear Robot Sensor World Time   % clear all user data
% cam = ipcam('http://172.30.56.42:8080/?action=stream'); % Youbot webcam
file = fopen('match','w');

%% IV. Main loop
for currentFrame = Tim.firstFrame : Tim.lastFrame
    
    % 1. SIMULATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Simulate robots
    for rob = [SimRob.rob]

        % Robot motion
        SimRob(rob) = simMotion(SimRob(rob),Tim);
%         
%         % Simulate sensor observations
%         for sen = SimRob(rob).sensors
%                
%             % Observe simulated landmarks
%             Raw(sen) =  simObservation(SimRob(rob), SimSen(sen), SimLmk, SimOpt) ;
% 
%         end % end process sensors
% 
%     end % end process robots

        for sen = Sen(1) % Sensor is chosen

            % Raw data is camera feed
            if currentFrame == Tim.firstFrame
                Raw(1).data = struct(...
                    'time',  f(currentFrame).time);
            end
            Raw(1) = struct(...
                'type',         'image',                    ...
                'data',         struct(                     ...
               ...For pre-recorded
                  'img',        f(currentFrame).image,      ... % Captures and rotates the image from the camera
                  'oldTime',    Raw.data.time,              ... % Captures last timestamp before reassigning
                  'time',       f(currentFrame).time)       ... % Captures the time that the snapshot was taken
               ...For real-time   
...%              'img',        rot90(snapshot(cam)),       ... % Captures and rotates the image from the camera
...%              'oldTime',    Raw.data.time,              ... % Captures last timestamp before reassigning
...%              'time',       datetime)                   ... % Captures the time that the snapshot was taken
                );

        end % end of sensor

    end    

    % 2. ESTIMATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Process robots
    for rob = [Rob.rob]

        % Robot motion
        % NOTE: in a regular, non-simulated SLAM, this line is not here and
        % noise just comes from the real world. Here, the estimated robot
        % is noised so that the simulated trajectory can be made perfect
        % and act as a clear reference. The noise is additive to the
        % control input 'u'.
        % Rob(rob).con.u = SimRob(rob).con.u + Rob(rob).con.uStd.*randn(size(Rob(rob).con.uStd));
        Rob(rob) = motion(Rob(rob),Tim);
        
        % Youbot motion
        % Changes the course of the Youbot if the simRob's vel changes
%         v = Rob(rob).state.x;
%         if any(Rob(rob).state.oldV ~= v(8:13))
%             disp('move')
%             Rob(rob) = userCommand(Rob(rob));
%         end
        
        Tim.dt = seconds(Raw.data.time - Raw.data.oldTime);
        Map.t = Map.t + Tim.dt; % Change dt here to the difference between the timestamps
        
        % Process sensor observations
        for sen = Rob(rob).sensors

            % Observe known landmarks
            [Rob(rob),Sen(sen),Lmk,Obs(sen,:)] = correctKnownLmks( ...
                Rob(rob),   ...
                Sen(sen),   ...
                Raw(sen),   ...
                Lmk,        ...   
                Obs(sen,:), ...
                Opt,        ...
                file) ;

            % disp([Obs(sen,1).meas.y;Obs(sen,1).exp.e])
            
            % Initialize new landmarks
            ninits = Opt.init.nbrInits(1 + (currentFrame ~= Tim.firstFrame));
            for i = 1:ninits
                [Lmk,Obs(sen,:)] = initNewLmk(...
                    Rob(rob),   ...
                    Sen(sen),   ...
                    Raw(sen),   ...
                    Lmk,        ...
                    Obs(sen,:), ...
                    Opt) ;
            end

        end % end process sensors

    end % end process robots

    % 3. VISUALIZATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if currentFrame == Tim.firstFrame ...
            || currentFrame == Tim.lastFrame ...
            || mod(currentFrame,FigOpt.rendPeriod) == 0
        
        % Figure of the Map:
        MapFig = drawMapFig(MapFig,  ...
            Rob, Sen, Lmk,  ...
            SimRob, SimSen, ...
            FigOpt);
        
        if FigOpt.createVideo
            makeVideoFrame(MapFig, ...
                sprintf('map-%04d.png',currentFrame), ...
                FigOpt, ExpOpt);
        end
        
        % Figures for all sensors
        for sen = [Sen.sen]
            SenFig(sen) = drawSenFig(SenFig(sen), ...
                Sen(sen), Raw(sen), Obs(sen,:), ...
                FigOpt);
            
            if FigOpt.createVideo
                makeVideoFrame(SenFig(sen), ...
                    sprintf('sen%02d-%04d.png', sen, currentFrame),...
                    FigOpt, ExpOpt);
            end
            
        end

        % Do draw all objects
        drawnow;
    end
    

    % 4. DATA LOGGING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO: do something here to collect data for post-processing or
    % plotting. Think about collecting data in files using fopen, fwrite,
    % etc., instead of creating large Matlab variables for data logging.
    

end
fclose(file);

%% V. Post-processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enter post-processing code here


% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

