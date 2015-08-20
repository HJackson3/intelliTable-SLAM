global PT%MD PT % Mahalanobis distance and processing time

num_it  = 1; % Number of iterations for test

% mahDist = [];
proTim  = [];

% Run slamtb ten times; pause so that the robot can be reset
% for i = 1:num_it
    % create file names
%     mal_file = sprintf('mahalanobis_%d.t', i);
    pro_file = sprintf('processing_time.t');
    
    % Open files for storing metrics
%     MD = fopen(mal_file, 'w');
    PT = fopen(pro_file,'w');

    robSlam; % Run robSlam
    
    % Close all files
    fclose('all');
% end
% 
% Load the files used for post-processing
% for i = 1:num_it
%     create file names
%     mal_file = sprintf('mahalanobis_%d.t', i);
%     pro_file = sprintf('processing_time%d.t', i);
%     
%     load files
%     if i>1
%         x = load(mal_file);
%         y = load(pro_file);
%         mahDist(:,i)    = x(1:min([length(x) length(mahDist)]));
%         proTim(:,i)     = y(1:min([length(y) length(proTim)]));
%     else
%         mahDist(:,i)    = load(mal_file);
%         proTim(:,i)     = load(pro_file);
%     end
%     
%     Exclude excessively large values;
%     md = mahDist(:,i);
%     pt = proTim(:,i);
%     
%     m_std = std(md); % Standard deviations
%     p_std = std(pt);
% 
%     m_mean_tmp = mean(md);
%     p_mean_tmp = mean(pt);
% 
%     Remove variables larger than 3-sigma from the mean
%     m_sigTh = m_std + m_mean_tmp; % Threshold
%     p_sigTh = p_std + p_mean_tmp;
% 
%     m_out_bound = md < m_sigTh; % Find out of bound values
%     p_out_bound = pt < p_sigTh;
%     
%     md(m_out_bound) = mean(md(~m_out_bound));% Assign them to the mean value
%     pt(p_out_bound) = mean(pt(~p_out_bound));
% end
% 
% 
% Compute the averages
% m_mean = mean(mahDist');
% p_mean = mean(proTim');
% 
% Calculate overall avg mahalanobis and process time
% m_avg = mean(m_mean);
% p_avg = mean(p_mean);
% 
% Show the averages in the console
% fprintf('Average mahalanobis distance:\t%s\n', m_avg);
% fprintf('Average processing time:\t\t%s\n', p_avg);
% 
% Show the figures for the individual values
% figure(3);plot(p_mean);hold on
% plot(1:numel(p_mean),p_avg*ones(size(p_mean)));title('Processing time.t');xlabel('Frame');ylabel('Time');hold off
% figure(4);plot(m_mean);hold on
% plot(1:numel(m_mean),m_avg*ones(size(m_mean)));title('Mahalanobis distance squared.t');ylabel('Mahalanobis distance squared');hold off