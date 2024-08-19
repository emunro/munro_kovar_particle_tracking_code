function [segmentIndex, arcLengthOnSegment, arcLengthOnPath] = projPointsToSmoothedCurve(trk,sgWindowWidth)

% projPointsToSmoothedCurve:  For the given trajectory, projects raw x,y positions onto a smoothed version 
% of the same trajectory, using the Savitsky Golay filter. Returns arrays containing the indices of the segments 
% to which each point projects, the local arclength of the projected 
% points along these segments and the global arclength along the path


% Inputs:

% trk               =       a particle trajectory in simple format
%
%   'first' =   the first movie frame in which this track appears
%   'last' =    the last movie frame in which this track appears.
%   'lifetime' = the length of the track in frames.
%   'x' = an array containing the sequence of x positions.
%   'y' = an array containing the sequence of y positions.
%   'I' = an array containing the intensity values.


% sgWindowWidth     =      size of the smoothing window used by the SavitskyGolay filter


% Outputs:

%   segmentIndex    =       An array containing the indices of the projected segments of arclengths along the smoothed curve, measured
%                           from its beginning
%
%   arcLengthOnSegment  =   A list of arclengths along the smoothed curve, measured
%                           from its beginning
%
%   arcLengthOnPath     =   A list of arclengths along the smoothed curve, measured
%                           from its beginning

% initialize

    path = vertcat(trk.x,trk.y);
    sx = smoothdata(trk.x,'sgolay',sgWindowWidth);
    sy = smoothdata(trk.y,'sgolay',sgWindowWidth);
    smoothedPath = vertcat(sx,sy);
    arcLengths = getArclengths(smoothedPath);

    nPoints = trk.lifetime;
    segmentIndex = zeros(1,nPoints);
    arcLengthOnSegment = zeros(1,nPoints);
    arcLengthOnPath = zeros(1,nPoints);

    
    % loop through all points along trajectory
    for i = 1:nPoints
        
        % project current raw point onto current trajectory segment
        P = path(:,i);
        seg = i;
        if i == nPoints
            seg = nPoints-1;
        end
        P1 = smoothedPath(:,seg);
        P2 = smoothedPath(:,seg+1);
                
        [alpha,dS] = projPointToLine(P,P1,P2);

        
        if alpha < 0    % projected point before segment start; back up
            while seg > 1 & alpha < 0
                seg = seg - 1;
                P2 = P1;
                P1 = smoothedPath(:,seg);
                [alpha,dS] = projPointToLine(P,P1,P2);
            end
            if alpha < 1
                segmentIndex(i) = seg;
                arcLengthOnSegment(i) = dS;
                arcLengthOnPath(i) = arcLengths(seg) + dS;
            else
                segmentIndex(i) = seg;
                arcLengthOnSegment(i) = 0;
                arcLengthOnPath(i) = arcLengths(seg);
            end
        
        elseif alpha > 1    % projected point after segment end; go forward
            while seg < nPoints-1 & alpha > 1
                seg = seg + 1;
                P1 = P2;
                P2 = smoothedPath(:,seg+1);
                [alpha,dS] = projPointToLine(P,P1,P2);
            end
            if alpha > 0
                segmentIndex(i) = seg;
                arcLengthOnSegment(i) = dS;
                arcLengthOnPath(i) = arcLengths(seg) + dS;
            else 
                segmentIndex(i) = seg;
                arcLengthOnSegment(i) = 0;
                arcLengthOnPath(i) = arcLengths(seg);
            end            
        else    % projected point within segment.
            segmentIndex(i) = seg;
            arcLengthOnSegment(i) = dS;
            arcLengthOnPath(i) = arcLengths(seg) + dS;
        end
    end

end

