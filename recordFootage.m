function f = recordFootage(x)
%RECORDFOOTAGE records footage using the robot that can be debugged
% 
% 
% 
% 

% Initialise youbot and camera
yb = Youbot('youbot2');
cam = ipcam('http://172.30.56.42:8080/?action=stream');

% Form for each piece of footage
f(500) = struct(...
    'image',    [],...
    'time',       datetime...
    );

% Set up youbot
yb.ArmPosition([1.4,1.2,-2.6,0.3,2.9]);
pause(2.0);
yb.BaseVelocity(x,0,0);

% Collect some images
for n = 1:500
    
    f(n) = struct(...
        'image',    rot90(snapshot(cam)),...
        'time',     datetime);
    pause(0.01);
    
end

yb.Stop();
yb.StowArm();

end