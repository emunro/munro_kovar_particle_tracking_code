function[] = ml_pretrack(basepath, in,featuresize,minPeakIntensity, minIntegratedIntensity, haloSize)

% This program should be used when you have determined the values of its
% parameters using mpretrack_init. The calling sequence is
% essentially the same. The features and found by calling feature2D (with
% parameters other than feature size hardcoded).
%
% Note: feature2D requires the Image processing toolbox due to a call to
% imdilate in the localmax subfunction. Use feature2D_nodilate for an
% alternative which works almost as well.
%
% INPUTS :

% basePath                  =               the name of the basePath
%
% in                        =               the  sequence of raw frames
%
% minPeakIntensity          =               the minimum intensity of local peaks to consider in the first step of particle detection
%                                           read from Min intensity setting in Kilfoil Pretrack GUI.
%
% minIntegratedIntensity       =            the minimum integhrated intensity of local peaks to consider in the second step of particle detection
%                                           read from Int intensity setting
%                                           in Kilfoil Pretrack GUI.
%
% featureSize               =           the particle feature sizeto use, read from the Feature Size setting in Kilfoil Pretrack GUI 
%
% haloSize                  =           the width of an annular region around the feature in which to meausure background intensity so as to 
%                                       produce a backgorund subtracted integrated intensity measurement

% OUTPUTS
%
% - Creates a subfolder called "Feature_Finding" where it outputs the
% accepted features' MT matrix (from feature2D) as "MT_##_Feat_Size_"
% featuresize ".mat"
% - copies last frame into same subfolder
%
% MT matrix format:
% 1 row per feature per frame, sorted by frame number then x position (roughly)

% columns:
%   MT(:,1)   - X centroid position (in pixels)
%   MT(:,2)   - Y centroid position (in pixels)
%   MT(:,3)   - Integrated intensity
%   MT(:,4)   - background-subtracted integrated intensity
%   MT(:,5)   - frame #
%

tic,

pathin  = basepath;
pathout = [pathin 'Feature_finding/'];
[status, message, messageid] = mkdir( pathout );

d=0;
numframes = size(in,3);
for frm = 1:numframes
    img=in(:,:,frm);

    M = findFeatures(img,featuresize,minPeakIntensity,haloSize);

    if mod(frm,50) == 0
        disp(['Frame ' num2str(frm)])
        % partway save, useful if the computer tends to crash for some
        % reason
%         save([pathout 'MT_' num2str(fovn) '_Feat_Size_' num2str(featuresize) '_partial.mat'] ,'MT')
    end

    [a,b]=size(M);
    
    if not(isempty(M))   
        % Reject features with integrated intensity less than threshold
        M=M(M(:,3)>minIntegratedIntensity,:);

        a = size(M,1);
        MT(d+1:d+a, 1:3) = M(1:a,1:3);  %x,y,intensity
        MT(d+1:d+a, 4) = M(1:a,4);        % background-subtracted intensity
        MT(d+1:d+a, 5) = frm;            % frame
        d = length(MT(:,1));
        disp([num2str(a) ' features kept.'])
    end
end

format long e;
save([pathout 'MT_Feat_Size_' num2str(featuresize)],'MT')


clear all;
format short;

disp(['The program ran for ' num2str(toc/60) ' minutes'])
