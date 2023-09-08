function [ handle] = plotMSDVSTau(tracks,minTrackSize,movieInfo, logplot, montage)

% Given an array of particle tracks, estimate the mean square displacement
% (MSD) vs timelag tau for tracks with length > minTrackLength and
% plot these in postage stamp format.  
% Note: Format is that same as for plotMSDTrajectories for easy comparison.



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

% movieInfo         =   a struct containing the following fields:
%     
%     baseName:       original datafile name minus the ".tif" ext
%     frameRate:      in #/sec
%     pixelSize:      in µm
%     firstFrame      first frame of movie segment 
%     length:         length of movie segment in frames
%     APOrientation:  0 if anterior is to the left; 1 if it is to the right 
% 
% Output:

% handle = a graphics handle for the plot.

    maxTrackSize = max([tracks.lifetime]);
    trks = tracks([tracks.lifetime]>minTrackSize);
    numTracks = size(trks,2)
    X = 1:maxTrackSize;
    frameInterval = 1/movieInfo.frameRate;
    X=X*frameInterval;    

    nRows = floor(sqrt(numTracks));         %number of rows
    nCols = floor(numTracks/nRows) + 1;     %number of cols

    if montage 
        figure;     %plot selected tracks
        if logplot
            for i=1:numTracks  
                subplot(nRows,nCols,i);
                loglog(X,4*0.1*X,'color','g');        
                hold on;
                loglog(X,4*0.1*X.^2,'color','r');        
                msd = getMSDvsTAU(trks(i),floor(trks(i).lifetime/1),movieInfo);
                loglog(X(1:size(msd,2)),msd);
                char=num2str(i);
                title(char);
                xlim([frameInterval,frameInterval*maxTrackSize]);
                ylim([0.001,10]);
            end
        else
            for i=1:numTracks  
                subplot(nRows,nCols,i);
                plot(X,4*0.1*X,'color','g');        
                hold on;
                plot(X,4*0.1*X.^2,'color','r');        
                msd = getMSDvsTAU(trks(i),floor(trks(i).lifetime/1),movieInfo);
                plot(X(1:size(msd,2)),sqrt(msd));
                char=num2str(i);
                title(char);
                xlim([frameInterval,frameInterval*maxTrackSize]);
                ylim([0,5]);
            end
        end 
    else
        if logplot
            figure;
            loglog(X,4*0.1*X,'color','g');        
            hold all;
            loglog(X,4*0.1*X.^2,'color','r');   
            for i=1:numTracks  
                msd = getMSDvsTAU(trks(i),floor(trks(i).lifetime/1),movieInfo);
                loglog(X(1:size(msd,2)),msd);
            end
            xlim([frameInterval,frameInterval*maxTrackSize]);
            ylim([0.001,10]);
        else
            figure; 
            plot(X,4*0.1*X,'color','g');        
            hold all;
            plot(X,4*0.1*X.^2,'color','r');   
            for i=1:numTracks  
                msd = getMSDvsTAU(trks(i),floor(trks(i).lifetime/1),movieInfo);
                plot(X(1:size(msd,2)),sqrt(msd));
            end
            xlim([frameInterval,frameInterval*maxTrackSize]);
            ylim([0,5]);
        end 
    end
   


end



