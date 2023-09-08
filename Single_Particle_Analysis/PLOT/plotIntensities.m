function handle = plotIntensities(trackList,minTrackLength,montage)
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

% montage = 1  -> plot in postage stamp format
% montage = 0 - > overlay all traces on same plot
% 
% Output:

% handle = a graphics handle for the plot.


trackList = trackList([trackList.lifetime]>minTrackLength);
numTracks = size(trackList,2);
m=sqrt(numTracks)-mod(sqrt(numTracks),1);     %number of rows
if mod(sqrt(numTracks),1)~=0
    m=m+1;
end
n=numTracks/m-mod(numTracks/m,1);     %number of cols
if mod(numTracks/m,1)~=0
    n=n+1;
end

maxI = 0; minI = 0;
maxT = 0; 
for i = 1:numTracks

    dum = max(trackList(i).I);
    if dum>maxI
        maxI = dum;
    end
    dum = min(trackList(i).I);
    if dum<minI
        minI = dum;
    end
    if trackList(i).lifetime>maxT
        maxT = trackList(i).lifetime;
    end
end
    
if montage 
    figure;     %plot selected tracks
    for i=1:numTracks
        subplot(m,n,i);
        plot(trackList(i).I);
        xlim([1,maxT]);
        ylim([minI,maxI]);
        char=num2str(i);
        title(char);
    end
else
    figure;     %plot selected tracks
    xlim([1,maxT]);
    ylim([minI,maxI]);
    hold all;
for i=1:numTracks
    plot(trackList(i).I);
end
   

handle=gcf;

end

