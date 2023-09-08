
    %%%%%%%%%%%%%%%%%%%%%   LOAD IN TRACKING DATA  %%%%%%%%%%%%%%%%%%%%%

    clear all;

    % load trajectories and tracking info
    load('info.mat');
    load('trks.mat');

    % determine numbers of embryos and sampled parameters
    numEmbryos = size(trks,1);
    numParameterVals = size(trks,2);

    % determine max lifetime and max number of trajectories (per embryo) %
    maxLifetime = 1;
    maxNumTrajectories = 1;
    for i = 1:numEmbryos
        for j = 1:numParameterVals
            maxLifetime = max(maxLifetime, max([trks{i,j}.lifetime]));
            maxNumTrajectories = max(maxNumTrajectories, length(trks{i,j}));
        end
    end
    maxTime = 3;


    %%%%%%%%%%%%%%%%%%%%%    OPTIONAL STEP: use ROIs to filter trajectories  %%%%%%%%%%%%%%%%%%%%%
    % Use a mask to select trajectories belonging to a particular region of interest (ROI). 
    % Embryo-specific masks should reside in the folders e1, e2, etc that contain the image data. They should be called Mask.tif
    % They should have the same dimensions as the individual data frames. Pixel values should be set to non-zero non-zero within the ROI and zero elsewhere 
    % (use selection->create Mask in ImageJ)

    % set working directory to current directory
    workingDir = pwd;                     

    % get list of sub-directories with names "e1", "e2", etc
    dirList = getDirectoryList('e');      

    % load embryo-specific masks and use to filter trajectories
    for i = 1:numEmbryos 
        dirName = [workingDir '/' dirList{i} '/'];
        Mask = imread(strcat(dirName,'AMask.tif'));

        for j = 1:numParameterVals    
            trks{i,j} = filterByROI(trks{i,j},Mask,'birth');
        end
    end
    
  %%%%%%%%%%%%%%%%%%%%%    END OPTIONAL STEP  %%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%   COMPUTE AND PLOT DECAY CURVES FOR INDIVIDFUAL EMBRYOS  %%%%%%%%%%%%%%%%%%%%%

    % compute decay curves
    decayCurves = zeros(numEmbryos,numParameterVals,maxLifetime);
    for j = 1:numParameterVals            
        for  i = 1:numEmbryos
            decayCurves(i,j,:) = decay(trks{i,j},info,maxLifetime);
        end
    end

    % plot decay curves for individual embryos
    if numParameterVals > 1 
        figure
        for j = 1:numParameterVals            
            subplot(1,numParameterVals,j); hold;
            for  i = 1:numEmbryos
                nmax = decayCurves(i,j,1);
                plot((1:maxLifetime)/info.frameRate,log(squeeze(decayCurves(i,j,:))/nmax));
                ylim([-log(maxNumTrajectories) 0]);
                xlim([0 maxTime]);
            end
        end
    else
        figure; hold;
        for  i = 1:numEmbryos
            nmax = decayCurves(i,1,1);
            plot((1:maxLifetime)/info.frameRate,log(squeeze(decayCurves(i,1,:))/nmax));
            ylim([-log(maxNumTrajectories) 0]);
            xlim([0 maxTime]);
        end
    end

    %%%%%%%%%%%%%%%%%%%%%   COMPUTE AND PLOT MEAN DECAY CURVES (OVER ALL EMBRYOS)  %%%%%%%%%%%%%%%%%%%%%

    % compute mean decay curves over all embryos for different parameter values
    meanDecayCurves = squeeze(mean(decayCurves,1));

    % plot
    if numParameterVals > 1 
        figure;  
        for j = 1:numParameterVals
            subplot(1,numParameterVals,j); hold;
            nmax = meanDecayCurves(j,1);
            plot((1:maxLifetime)/info.frameRate,log(meanDecayCurves(j,1:maxLifetime)/nmax));         
            ylim([-log(maxNumTrajectories) 0]);
            xlim([0 maxTime]);
        end
    else
        figure;
        nmax = meanDecayCurves(1,1);
        plot((1:maxLifetime)/info.frameRate,log(meanDecayCurves(1,1:maxLifetime)/nmax));         
        ylim([-log(maxNumTrajectories) 0]);
        xlim([0 maxTime]);
    end


  %%%%%%%%%%%%%%%%%%%%%   COMPUTE AND PLOT DECAY RATES  %%%%%%%%%%%%%%%%%%%%%

    % compute decay rates
    decayRates = zeros(numEmbryos,numParameterVals,3);

    % pick timespan over which the decay curves are ~linear
    firstT = 0.2;
    lastT = 0.9;
    for j = 1:numParameterVals            
        for  i = 1:numEmbryos
             decayRates(i,j,:) = getDecayRate(squeeze(decayCurves(i,j,:)),firstT,lastT,info);
        end
    end

    if numParameterVals > 1 
        figure;
        for j = 1:numParameterVals            
            subplot(1,numParameterVals,j); hold;
            boxplot(decayRates(:,j));
        end
    else
        figure;
        boxplot(decayRates(:,1));
    end
    
    % compute and plot mean square displacements for a fixed time lag tau

    % specify time lag tau in seconds
    tau = 0.2;

    % allocate storage for msds.
    MSDs = cell(numParameterVals);

    % compute msds
    for j = 1:numParameterVals    
        MSDs{j} = [];
        for  i = 1:numEmbryos
            msd = getMSDatTAU(trks{i,j},tau,info);   
            MSDs{j} = [MSDs{j} msd(msd>0)];
        end
    end

    % compute maximum RMSD over all sampled partameter values
    maxMSD = 0;
    for j = 1:numParameterVals    
        maxMSD = max(maxMSD,max(MSDs{j}));
    end
    maxRMSD = sqrt(maxMSD);

    % compute a corresponding estimate of the RMSDs for molecules
    % undergoing random diffusion
    numSamples = 10000;

    % standard deviation of particle location error
    errSTD = 0.05;

    % diffusivity
    D = 0.1;

    rmsdSample = sampleRMSD(tau, numSamples,D,errSTD);

    % plot rmsds and overlay the estimate
    binwidth = maxRMSD/30;
    figure;  
    for i = 1:numParameterVals  
        subplot(2,numParameterVals,i); hold
        histogram(sqrt(MSDs{i}),'BinWidth',binwidth,'Normalization','probability');
        histogram(rmsdSample,'DisplayStyle','stairs','BinWidth',binwidth,'Normalization','probability');
        xlim([0,maxRMSD]);
        ylim([0 0.3]);
    end

    save('decayCurves.mat','decayCurves');




