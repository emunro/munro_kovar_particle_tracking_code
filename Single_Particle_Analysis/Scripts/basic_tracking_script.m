clear all;
workingDir = pwd;

%%%%%%%%%%%%  particle detection parameters  %%%%%%%%%%%%%%%%%%%
    info.frameRate = .666667;                  % acquisition frame rate
    info.pixelSize = 0.107;               % original pixel size

%%%%%%%%%%%%  particle detection parameters  %%%%%%%%%%%%%%%%%%%
    minPeakIntensity = 1234;
    minIntegratedIntensity = 30000;
    featureSize = 3; 
    haloSize = 1;

    info.minPeakIntensity = minPeakIntensity;               % min peak intebnsity to accept (from Kilfoil_Pretrack_GUI)
    info.minIntegratedIntensity = minIntegratedIntensity;        % min integrated intensity to accept (from Kilfoil_Pretrack_GUI)
    info.featureSize = featureSize;                       % feature size to use (from Kilfoil_Pretrack_GUI)
    info.haloSize = haloSize;                          % width in pixels of annular halo around feaure in which to calculate intensity
                                                % for background subtraction

%%%%%%%%%%%%  define segments of image sequence to track  %%%%%%%%%%%%%%%%%%%
    info.firstFrame = 1;                         % first frame of sequence to analyse
    info.lastFrame = 500;                       % last frame of sequence to analyse
    info.numFramesInTrackedInterval = 500;       % Break sequence into smaller chunks to increase efficiency

%%%%%%%%%%%%  parameters for ScriptTrackGeneral %%%%%%%%%%%%%%%%%%%    
    defineScriptTrackGeneralParameters = 1;  
    gapClosingTimeWindow = 3;  % maximum allowed time gap (in frames) between a track segment end and a track segment start that allows linking them.
    gapClosingMergeSplit = 1;  % set to: 1 if merging and splitting considered, 2 if only merging considered, 3 if only splitting considered, 0 if neitherconsidered.
    includeCompoundTracks = 1;  % set to 1 if you want to extract segments of compound tracks in your analysis, 0 otherwise

    if defineScriptTrackGeneralParameters == 1    
        info.gapClosingTimeWindow = gapClosingTimeWindow;       
        info.gapClosingMergeSplit = gapClosingMergeSplit; 
        info.includeCompoundTracks = includeCompoundTracks;              
    end  

%%%%%%%%%%%  specify a range of values to sample for some parameter  %%%%%%%%%%%
     info.parameterName = 'gapClosingTimeWindow';
     info.parameterVals = 3:3;

    % get list of directories with names "e1", "e2", etc
    dirList = getDirectoryList('e');   

    % compute numbers of embryos and parameter values sampled
    numParameterVals = length(info.parameterVals);
    numEmbryos = length(dirList);
    
    % Allocate storage for trajectories
    trks = cell(numEmbryos,numParameterVals);

    for i = 1:numEmbryos  
        dirName = [workingDir '/' dirList{i} '/'];
        tifName = [dirName 'e.tif'];

        % read in data and compute total number of frames to analyse
        in = readMultiFrameTiff(tifName);
        numAvailableFrames = size(in,3);
        info.lastFrame = min(info.lastFrame,numAvailableFrames);   
  
        for j = 1:numParameterVals

            % Assign a value to the varied parameter 
             gapClosingTimeWindow = info.parameterVals(j);

            % perform tracking for one embryo
            for fFrm = info.firstFrame:info.numFramesInTrackedInterval:info.lastFrame
                lFrm = min(fFrm+info.numFramesInTrackedInterval,info.lastFrame);
                frms = in(:,:,fFrm:lFrm);
                preTrack(dirName,frms,featureSize, minPeakIntensity,minIntegratedIntensity, haloSize);
                load([dirName 'Feature_finding/MT_Feat_Size_' num2str(info.featureSize) '.mat'])
                movieInfo = Kilfoil_to_uTrack_particles(MT,info.numFramesInTrackedInterval);
                scriptTrackGeneral;
                tracks = uTrack_to_simple_traj(tracksFinal,fFrm,lFrm,info, includeCompoundTracks);
                trks{i,j} = [trks{i,j} tracks(find([tracks.last] <= lFrm & [tracks.first] >= fFrm))];
            end  
        end
    end

    % save trajectories and info
    save('info.mat','info');
    save('trks.mat','trks');





