function  kymographs = getRelativeIntensityAlongTrajectories(im,trks,sgWindowWidth,pathWidth)
%getRelativeIntensityAlongTrajectories Compute the intensity of a signal along the path associated 
% with a particle trajectory as a function of distance from the moving front of the trajectory
% 
% Details:  Takes as input a list of trajectories, and an image stack representing either the original data from which the
% trajectories were made, or a second channel from the same multicolor image stack.  For each trajectory, computes a smoothed 
% path with the given pathWidth.  For each timepoint along the trajectory (and position along the path), calculates the 
% intensity of the signal at different distances along the path relative to particle position at that timepoint. 
% For each trajectory, the function
% computes the mean intensity at a relative distance over all particle
% positions.  The function then returns a 2D array in which the rows are
% the intensities vs relative distance for one trajectory.
%


%  Inputs

%   im      =           [height][width][nFrames] image stack to take the intensity
%
%   trks     =           an array of particle trajectories in simple format
%
%   'first' =   the first movie frame in which this track appears
%   'last' =    the last movie frame in which this track appears.
%   'lifetime' = the length of the track in frames.
%   'x' = an array containing the sequence of x positions.
%   'y' = an array containing the sequence of y positions.
%   'I' = an array containing the intensity values.
%
%   sgWindowWidth:    size of the window used to smooth trajectory 
%
%   pathWidth:          width of path along trajectory in whiich to sample
%                       data 
%
%  Output:  
%
%   kymograph  = [numTracks, max track lifetime] array containing average intensity
%   values along trajectory path relative to the moving particle for each
%   trajectory

    nTrks = length(trks);
    kymographs = nan(nTrks,max([trks.lifetime]));

    for i = 1:nTrks
        kymo = getRelativeIntensityAlongTrajectory(im,trks(i),sgWindowWidth,pathWidth);
        meanKymo = mean(kymo,1,'omitnan');
        meanKymo = flip(meanKymo);
        kymographs(i,1:length(meanKymo)) = meanKymo;
    end
    imshow(kymographs,[1 1000]);
end

