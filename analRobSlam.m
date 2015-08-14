global MD PT % Mahalanobis distance and processing time

% Open files for storing metrics
MD = fopen('mahalanobis.t','w');
PT = fopen('processing_time.t','w');

robSlam; % Run robSlam

% Close all files
fclose('all');

% Load the files used for post-processing
md = load('mahalanobis.t');
pt = load('processing_time.t');

% Exclude excessively large values; TO-DO

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