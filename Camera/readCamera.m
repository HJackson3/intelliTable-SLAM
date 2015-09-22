function Raw = readCamera( Raw, Rob, url, currentFrame )
%READCAMERA This function calls the frame from the camera object and
%returns the image
%   The camera object for the robot is called to receive the image; this
%   image is stored in a data structure that is read by the toolbox, with a
%   timestamp included.
%
%   currentFrame is used only for the footage but needs to be included
%   whenever it is called regardless.
%
%   Feel free to add as many models as necessary here for your specific
%   camera

switch Rob.footage.type % Set image and time values depending on the type of video feed
    
    % Model for the pre-recorded footage.
    case {'footage'}
        
        if currentFrame == Tim.firstFrame
            Raw.data = struct(...
                'time',  f(currentFrame).time);
        end
        img     = f(currentFrame).image;
        time    = f(currentFrame).time;
        
    % Model for the mjpeg ipcam.
    case {'ipcam'}
        img     = rot90(rot90(rot90(imread(url))));
        time    = datetime;
        
    otherwise
        error('Unknown footage type ''%s'' for robot %d.',Rob.camera.type,Rob.id);
        
end % End switch camera

% Final raw data structure created; this is how other functions refer to it
% so be careful if editing.
Raw.data =struct(                     ...
    'img',        img,                        ... Captures the rotated image from the camera
    'oldTime',    Raw.data.time,              ... Captures last timestamp before reassigning
    'time',       time                       ... Captures the time that the snapshot was taken
    );

end

