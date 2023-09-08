function handle = plotTrajectories(trks,minTrackLength,windowWidth)
% Given an array pf particle tracks, plots raw trajectories (x,y) for each
% track with length > minTrackLength in postage stamp format.  
% Note: Format is that same as for plotMSDVSTime for easy comparison.

% Inputs:

% trks = a list of particle tracks which is assumed to be in the format 
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
% windowWidth   = witsh of the savitsky golay filter window
%
% 
% Output:

% handle = a graphics handle for the plot.

polynomialOrder = 2;
    

trks = trks([trks.lifetime]>=minTrackLength);
trks = interpolateGaps(trks);
numTracks = size(trks,2);

nRows = floor(sqrt(numTracks));         %number of rows
nCols = floor(numTracks/nRows) + 1;     %number of cols

  
figure;     %plot selected tracks
maxX = max(cellfun(@max,{trks.x}) - cellfun(@mean,{trks.x}));
minX = min(cellfun(@min,{trks.x}) - cellfun(@mean,{trks.x}));
maxY = max(cellfun(@max,{trks.y}) - cellfun(@mean,{trks.y}))
minY = min(cellfun(@min,{trks.y}) - cellfun(@mean,{trks.y}));
for i=1:numTracks
    mx = trks(i).x-mean(trks(i).x);
    my = trks(i).y-mean(trks(i).y);
    sx = sgolayfilt(mx,polynomialOrder,windowWidth);
    sy = sgolayfilt(my,polynomialOrder,windowWidth);
    subplot(nRows,nCols,i);
    hold on;
    plot(mx,my);
    plot(sx,sy,'r');
    xlim([minX,maxX]);
    ylim([minY,maxY]);
    char=num2str(i);
    title(char);
end

handle=gcf;

end

