function objs = convert_to_objs(res)
%
% This function converts an objs_link array (output from im2obj_rp nnlink_rp) to
% the required column format of the kilfoil group:
%
% objs = 6xN array
%   Row 1: x position
%   Row 2: y position
%   Row 3: Particle Mass
%   Row 4: Particle ID
%   Row 5: Frame Number
%   Row 6: Track ID
%
% posstot = Nx4 array
%   Column 1: x position
%   Column 2: y position
%   Column 3: Frame Number
%   Column 4: Track ID

% Transpose the array
res = res';

% Preallocate
objs = zeros(6, length(res));

% Is this a cntrd?
if size(res,1) == 4;
    objs([1 2 5 6], :) = res([1 2 3 4],:);
else
    % Pull out relavent data and store in new format
    objs([1 2 5 6], :) = res([1 2 6 8],:);
end
end