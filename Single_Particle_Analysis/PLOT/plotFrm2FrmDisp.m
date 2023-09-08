function handle = plotFrm2FrmDisp(trks,minTrackLength,maxTrackLength, maxT, montage)
% Given an array of particle tracks, plots frame to frame displacements  vs time for each
% track with length > minTrackLength.  Plots either in postage stamp format or overlayed.

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

% montage = 1  -> plot in postage stamp format
% montage = 0 - > overlay all traces on same plot
% 
% Output:

% handle = a graphics handle for the plot.


trks = trks([trks.lifetime]>minTrackLength);
numTracks = size(trks,2);

maxTime = min(maxT,max([trackList.lifetime]); 
    
if montage 
    m=sqrt(numTracks)-mod(sqrt(numTracks),1);     %number of rows
    if mod(sqrt(numTracks),1)~=0
        m=m+1;
    end
    n=numTracks/m-mod(numTracks/m,1);     %number of cols
    if mod(numTracks/m,1)~=0
        n=n+1;
    end
    
    figure;     %plot selected tracks
    for i=1:numTracks
        subplot(m,n,i);
        dx = 0.1*(trks(i).x(2:trks(i).lifetime) - trks(i).x(1:trks(i).lifetime-1));
        dy = 0.1*(trks(i).y(2:trks(i).lifetime) - trks(i).y(1:trks(i).lifetime-1));
        tmp = (dx.*dx + dy.*dy).^0.5;
        plot(tmp);
        xlim([1,maxTime]);
        ylim([0,0.2]);
        char=num2str(i);
        title(char);
    end
else
    figure;     %plot selected tracks
    xlim([1,maxTime]);
    ylim([0,0.2]);
    hold all;
for i=1:numTracks
    plot(0.1*(trks(i).x-mean(trks(i).x)));
end
   

handle=gcf;

end

