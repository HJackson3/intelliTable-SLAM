https://www.facebook.com/TheOriginalBestOfTumblr/photos/a.252727674878437.1073741825.252714998213038/675976742553526/?type=1&theaterfunction Obs = matchFeature(Sen,Raw,Obs,sig,scTh)

% MATCHFEATURE  Match feature.
% 	Obs = MATCHFEATURE(Sen,Raw,Obs) matches one feature in Raw to the predicted
% 	feature in Obs.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch Obs.ltype(4:6)
    case 'Pnt'
        switch Raw.type
            case {'simu', 'dump'}
            	rawDataLmks = Raw.data.points;
            	R = Sen.par.pixCov;
            case 'image'
            	% Maybe stuff for image is needed?
            otherwise
                error('??? Unknown Raw data type ''%s''.',Raw.type)
        end
    case 'Lin'
        rawDataLmks = Raw.data.segments;
        R = blkdiag(Sen.par.pixCov,Sen.par.pixCov);
    otherwise
        error('??? Unknown landmark type ''%s''.',Obs.ltype);
end

switch Raw.type
    
    case {'simu','dump'}
        
        id  = Obs.lid;
        idx = find(rawDataLmks.app==id);
        
        if ~isempty(idx)
            Obs.meas.y   = rawDataLmks.coord(:,idx);
            Obs.meas.R   = R;
            Obs.measured = true;
            Obs.matched  = true;
        else
            Obs.meas.y   = zeros(size(Obs.meas.y));
            Obs.meas.R   = R;
            Obs.measured = false;
            Obs.matched  = false;
        end
        
    case 'image'
        %% Create variables for the rectangular search region, sRegion
        %  Centre is mean (Obs.exp.e) with bounds 3 sigma (sqrt. of diag.
        %  of Obs.exp.E).
        
        centre = round(Obs.exp.e);                % mean
        bounds = round(sqrt(diag(Obs.exp.E)));    % 3sigma in u and v direction.
        
        sBounds = [centre-bounds,centre+bounds];  % The search region for the feature
        if ~any(sBounds < 1)
            %% Create sRegion if it's within the region, otherwise just ignore
            % 
            
            sRegion = pix2patch(Raw.data.img,centre,2*bounds(1),2*bounds(2));
        
            %% Store the predicted appearance of the landmark in Obs.app.pred
            %  Resize the appearance using a rotation and zoom factor to
            %  predict appearance in new position.

            % xDiff = abs(sig.pose0 - Sen.frame.x);            % Rotation and zoom factor
            Obs.app.pred = sig.patch; % patchResize(sig.patch, xDiff);    % Predicted appeareance

            %% Scan the rectangular region for the modified patch using ZNCC
            pred = Obs.app.pred;

            % This current implementation is quite slow - find a way to
            % speed it up.
            
            % Scans the region to find the patch that best fits
            Obs.app.sc = 0;
            for i = 1:(sBounds(1,2)-sBounds(1,1)) % xBounds
                for j = 1:(sBounds(2,2)-sBounds(2,1)) % yBounds
                    rPatch = pix2patch(sRegion.I, [i;j], 15);
                    tmpSc = zncc(...
                        rPatch.I,...
                        pred.I,...
                        rPatch.SI,...
                        pred.SI,...
                        rPatch.SII,...
                        pred.SII);
                    disp(tmpSc)
                    
                    % If the score is the current highest then update the
                    % values
                    if tmpSc > Obs.app.sc
                        Obs.app.sc      = tmpSc;    % Setting score and current appearance
                        Obs.app.curr    = rPatch;   % for the patch
                        
                        x = sBounds(1,1)+i;
                        y = sBounds(2,1)+j;
                        Obs.meas.y      = [x;y];    % Store best pixel
                        Obs.measured    = true;
                    end
                end
            end
            
            %% Test if the zncc score is above the threshold
            %  If so, set Obs.matched to true.
            if Obs.app.sc > scTh
            	Obs.matched = true; 
            end
            
        end
        %% Error left in but commented out for possible future use.
        
        % error('??? Feature matching for Raw data type ''%s'' not implemented yet.', Raw.type)
        
        
    otherwise
        error('??? Unknown Raw data type ''%s''.',Raw.type)
        
end



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

