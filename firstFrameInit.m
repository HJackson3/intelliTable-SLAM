function [Raw, now] = firstFrameInit(Raw, Sen)
% FIRSTFRAMEINIT is the function for placing any actions or assignments
% that need doing in the first iteration of the slam algorithm

% Create 'now' variable; this is used to track the processing time for
% analysis. It is also used to initialise the time for the live Raw data.
now = datetime; 

for sen = [Sen.sen]
    Raw(sen) = struct(...
        'type',     'image',...
        'data',     struct(...
          'time',     now,...
          'oldTime',  now));
end

end