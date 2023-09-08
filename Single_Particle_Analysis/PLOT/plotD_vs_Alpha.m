function [ handle ] = plotD_vs_Alpha(tracks,tauMax, minTrackLength,movieInfo)
% Given a set of input tracks, estimates diffusivities and exponent alpha for 
% MSD vs time and plots their distributions.


% Inputs:

% tracks = a list of particle tracks which is assumed to be in the format 
% output by the function uTrackToSimpleTraj:
%
%   'first' =   the first movie frame in which this track appears
%   'last' =    the last movie frame in which this track appears.
%   'lifetime' = the length of the track in frames.
%   'x' = an array containing the sequence of x positions.
%   'y' = an array containing the sequence of y positions.
%   'I' = an array containing the intensity values.


% minTrackLength = minimum length of particle track in frames to include in
% the analysis.

% maxTau            Estimate D and alpha from MSD vs tau for tau <= maxTau.

% movieInfo         =   a struct containing the following fields:
%     
%     baseName:       original datafile name minus the ".tif" ext
%     frameRate:      in #/sec
%     pixelSize:      in µm
%     firstFrame      first frame of movie segment 
%     lastFrame:      last frame of movie segment 
%     APOrientation:  0 if anterior is to the left; 1 if it is to the right 
% 
% Output:

% handle = a graphics handle for the plot.

trks = tracks([tracks.lifetime]>minTrackLength);
numTracks = size(trks,2);
D = zeros(numTracks,1);
Alpha = zeros(numTracks,1);


for i=1:numTracks  
    [d a] = getDAlpha(trks(i),tauMax,movieInfo);
    D(i) = d;
    Alpha(i) = a;
end

figure
scatter(Alpha,D);
title('D vs alpha');
ylabel('D');
xlabel('alpha');


fprintf('the number of tracks longer than %d seconds is: %d.\n',minTrackLength/movieInfo.frameRate,numTracks);

handle = gcf;
end

