function[] = preTrack(basePath, in, featureSize, peakIntensityThreshold, integratedIntensityThreshold, haloSize)
%preTrack  This function acts as a "wrapper function" for the Klfoil
%mpretrack function, hiding the unimportant details.

% Inputs:
%
% basePath       =                    the name of the basePath
%
% in          =                       the sequence of raw frames
%
% peakIntensityThreshold    =           the minimum intensity of local peaks to consider in the first step of particle detection
%                                       read from Min intensity setting in Kilfoil Pretrack GUI                                      
% integratedIntensityThreshold       =           the minimum integhrated intensity of local peaks to consider in the second step of particle detection
%                                       read from Int intensity setting in Kilfoil Pretrack GUI 
% featureSize               =           the particle feature sizeto use, read from the Feature Size setting in Kilfoil Pretrack GUI 
%
% haloSize                  =           the width of an annular region around the feature in which to meausure background intensity so as to 
%                                       produce a backgorund subtracted integrated intensity measurement


    % call the kilfoil mopretrack function with our inputs
    ml_pretrack(basePath, in,featureSize,peakIntensityThreshold, integratedIntensityThreshold, haloSize);
end