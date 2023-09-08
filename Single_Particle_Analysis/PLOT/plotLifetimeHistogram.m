function [ h ] = plotLifetimeHistogram(tracks,logscale)
% Given an array of particle tracks, plots the histogram
% of trajectory lengths

% Inputs  

%    tracks:    a list of particle tracks which is assumed to be in the format 
%           output by the function uTrackToSimpleTraj:
%
%   'first' =   the first movie frame in which this track appears
%   'last' =    the last movie frame in which this track appears.
%   'lifetime' = the length of the track in frames.
%   'x' = an array containing the sequence of x positions.
%   'y' = an array containing the sequence of y positions.
%   'I' = an array containing the intensity values.

%
%   logscale:   if 1, plot on logscale, if 0, plot linear

    figure;
    if logscale
        histogram(log10([tracks.lifetime]));
    else
        histogram([tracks.lifetime]);
    end    
end

