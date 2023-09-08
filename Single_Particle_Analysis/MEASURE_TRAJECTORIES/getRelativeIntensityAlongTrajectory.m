function  intensities = getRelativeIntensityAlongTrajectory(im,trk,sgWindowWidth,pathWidth,showKymo)
%getRelativeIntensityAlongTrajectory 

% For the given trajectory, computes a smoothed path with the given pathWidth.  For each timepoint along the trajectory 
% (and position along the path), calculates the intensity of the signal at different distances along the path relative to 
% particle position at that timepoint. Then avewrages over all points along thre trajectory to get the average intensity 
% relative to position of the moving particle.


%  Inputs

%   im      =           [height][width][nFrames] image stack to take the intensity
%
%   trk     =           a particle trajectory in simple format
%
%   'first' =   the first movie frame in which this track appears
%   'last' =    the last movie frame in which this track appears.
%   'lifetime' = the length of the track in frames.
%   'x' = an array containing the sequence of x positions.
%   'y' = an array containing the sequence of y positions.
%   'I' = an array containing the intensity values.
%
%   sgWindowWidth   =    size of the window used to smooth trajectory 
%
%   pathWidth   =          width of path along trajectory in whiich to sample data 
%
%   showKymo    =           flag that determines whther to plot the
%                           kymograph.  If a non-zero value for showKymo is specified, show the
%                           plot; otherwise ignore
%  Output:
%
%  intenasities = array of average inteneisties relative to moving particle
%  position.


    path = vertcat(trk.x,trk.y);
    sx = smoothdata(trk.x,'sgolay',sgWindowWidth);
    sy = smoothdata(trk.y,'sgolay',sgWindowWidth);
    smoothedPath = vertcat(sx,sy);

    nSegments = length(path)-1;
    path = flip(path,2);
    smoothedPath = flip(smoothedPath,2);

    [segmentIndex, arcLengthOnSegment, arcLengthOnPath] = projPointsToSmoothedCurve(path,smoothedPath);

    pixelLength = floor(arcLengthOnPath(end));
    intensities = nan(trk.lifetime-1,pixelLength);
    
    frm = trk.last;
    for i = 1:nSegments
        firstSegment = segmentIndex(i);
        firstS = arcLengthOnSegment(i);
        pixelList = pixelizePath(smoothedPath(:,firstSegment:nSegments),pathWidth,firstS);
        interpolatedVals = straightenPath(im(:,:,frm),pixelList);
        interpolatedVals = transpose(interpolatedVals);
        intensities(i,1:length(interpolatedVals)) = interpolatedVals;
        frm = frm - 1;
    end
    intensities = flip(intensities,2);

    if nargin > 4 && showKymo
        imshow(intensities,[1 1000]);
    end
end

