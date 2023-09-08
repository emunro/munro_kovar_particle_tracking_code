% grab_track.m
%
% This function takes a given track ID and pulls all of the relavent
% objs_link and msd information for the given track
%
% Chris Harland
% 20090520
%

function [single_objs single_msd] = grab_track(objs, id, fps, scale)

% Pull out all of the desired positions
single_objs = objs(:,objs(6,:)==id);
if nargin>2
    % Calculate the MSD for this track
    single_msd = msdtr_rp(single_objs, fps, scale);
end

end