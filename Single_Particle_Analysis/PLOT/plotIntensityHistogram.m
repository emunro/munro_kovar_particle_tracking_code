function handle = plotIntensityHistogram(trks,minTrackLength)
% Given an array of particle tracks, plots Intensity values vs time for each
% track with length > minTrackLength.  Plots either in postage stamp format or overlayed.
% Note: Format is that same as for plotMSDVSTime for easy comparison.

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

% 
% Output:

% handle = a graphics handle for the plot.


trks = trks([trks.lifetime]>minTrackLength);
numTracks = size(trks,2);

intensities = zeros(numTracks,1);
for i=1:numTracks  
    %intensities(i) = mean(trks(i).I);
    intensities(i) = max(trks(i).I);
end

figure; hold;
%binwidth = max(intensities)/30;
binwidth = 140000/30;
histogram(intensities,'BinWidth',binwidth,'Normalization','probability');
   

handle=gcf;

end

