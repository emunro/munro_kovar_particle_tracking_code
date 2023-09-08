function slopes = plotSpeedHistogram(trks,movieInfo, sgolay)
% Compute msd vs tau for tau < maxTau

% Inputs:

% trks = an array of particle tracks in simple format
%
%   'first' =   the first movie frame in which this track appears
%   'last' =    the last movie frame in which this track appears.
%   'lifetime' = the length of the track in frames.
%   'x' = an array containing the sequence of x positions.
%   'y' = an array containing the sequence of y positions.
%   'I' = an array containing the intensity values.


% movieInfo         =   a struct containing the following fields:
%     
%     baseName:       original datafile name minus the ".tif" ext
%     frameRate:      in #/sec
%     pixelSize:      in µm
%     firstFrame      first frame of movie segment 
%     lastFrame:      last frame of movie segment 
%     APOrientation:  0 if anterior is to the left; 1 if it is to the right 


% 
% Output

% speeds    array of speeds

    numTracks = size(trks,2)
    speeds = zeros(numTracks,1);

    for i=1:numTracks  
        speeds(i) = getSpeed(trks(i),movieInfo,sgolay);
    end

    figure; hold;
    binwidth = max(speeds/30);
    histogram(speeds,'BinWidth',binwidth,'Normalization','probability');

end



