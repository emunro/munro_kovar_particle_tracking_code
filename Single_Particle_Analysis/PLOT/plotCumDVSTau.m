function plotCumDVSTau(axes,trks,movieInfo, sgWindowSize, montage)

%  plotCumDVSTau:  Takes a an array of trajectories in simple format. Uses the getCumDvsTAU functiuon to 
%  compute cumulative distances along smoothed version of each trajectory,
%  then plots the cumulative displacements for all trajectories overlaid in
%  a single plot or as a montage of individual plots



% Inputs:

% axes  = the axes on which to plot

% trks = a list of particle tracks which is assumed to be in the format 
% output by the function uTrackToSimpleTraj:
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
%     length:         length of movie segment in frames
%     APOrientation:  0 if anterior is to the left; 1 if it is to the right 
% 
% sgWindowSize      =   size of the smoothing window used by the SavitskyGolay filter
%
% montage           =   a flag that determines whether to plot the curves
%                       as a montage or as a single overlaid plot

    maxTrackSize = max([trks.lifetime]);
    numTracks = size(trks,2)
    X = 1:maxTrackSize;
    frameInterval = 1/movieInfo.frameRate;
    X=X*frameInterval;   
    
    if montage 
        for i=1:numTracks
            cumD = getCumDvsTAU(trks(i),movieInfo,sgWindowSize);
            plot(axes{i},X(1:size(cumD,2)),cumD);
            xlim(axes{i},[0,frameInterval*maxTrackSize]);
            ylim(axes{i},[0,10]);
            char=num2str(i);
            title(axes{i},char);
        end
    else
        xlim(axes,[0,frameInterval*maxTrackSize]);
        ylim(axes,[0,10]);
        hold(axes,'on');
        for i=1:numTracks
            cumD = getCumDvsTAU(trks(i),movieInfo,sgWindowSize);
            plot(axes,X(1:size(cumD,2)),cumD);
        end
    end
end



