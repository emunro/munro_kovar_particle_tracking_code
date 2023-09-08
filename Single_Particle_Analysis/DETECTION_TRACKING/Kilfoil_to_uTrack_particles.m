function [ out ] = Kilfoil_to_uTrack_particles(particles, nFrames)
%Kilfoil_to_uTrack_particles Transforms a set of particle data produced by Kilfoil
%preTråck into format for tracking by uTrack.  Extracts a subset of data defined 
% by firstfarme and nrames.

%  Inputs
%
%   particles:  An array of particles in Kilfoil format
%   firstFrame: First frame to extract
%   nFrames: Total number of frames to extrract.
%
%   Outputs
%
%   out:  An array of structures with length nFrames, where each structure
%   defines a list of particles with the following fields:
%
%   xCoord: An array of x coordinates, one for each particle
%   yCoord: An array of y coordinates, one for each particle
%   amp: An array of intensities, one for each particle

    out(nFrames,1) = struct('xCoord',[],'yCoord',[],'amp',[]);
    for frm = 1:nFrames
        tmp = particles(particles(:,5) == frm,:);
        sz = size(tmp,1);
        out(frm,1).xCoord = [tmp(:,1) zeros(sz,1)];
        out(frm,1).yCoord = [tmp(:,2) zeros(sz,1)];
        out(frm,1).amp = [tmp(:,4) zeros(sz,1)];
    end
end

