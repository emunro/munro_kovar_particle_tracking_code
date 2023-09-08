% find_long_track.m
%
% This function returns the ID of the n longest tracks in an objs array.
%
% Chris Harland
% 2011.01.28
%
%

function [trlength] = find_long_track(objs)

% get the track length for all tracks
trlength = zeros(2,length(unique(objs(6,:))));
disp('Finding all track lengths');
k = 1;
for i = unique(objs(6,:));
    templength = length(objs(1,objs(6,:)==i));
    trlength(:,k) = [i; templength];
    k = k+1;
end
trlength = sortrows(trlength',2)';
disp('Done!');
end