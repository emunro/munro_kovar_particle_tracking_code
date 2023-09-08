function r = findFeatures(img,featureSize,minPeakIntensity,haloSize)
% A MunroLab wrapper for the Kilfoil feature2D function.  

%  Inputs
%
%   img =               a single movie frame 
%   featureSize =       radius of the feature mask
%   minPeakIntensity =  min intensity of detected peaks
%   haloSizeparticles = size of the annular halo arond fesatures to sample for background intensity
%
%   Outputs
%
% 		r(:,1):	the x centroid positions, in pixels.
% 		r(:,2): the y centroid positions, in pixels. 
% 		r(:,3): integrated brightness of the features. ("mass")
% 		r(:,4): background-subtracted integrated brightness of the features





lambda = 1;   % spatial scale for noise filter ion pixels
masscut = 0;  % do not make a rough cut on mass
field = 2;    % assume standard video frames

r = feature2D(img,lambda,featureSize,masscut,minPeakIntensity,field,haloSize);
if r == -1
    r = [];
else
    r = r(:,[1:3 6]);
end


