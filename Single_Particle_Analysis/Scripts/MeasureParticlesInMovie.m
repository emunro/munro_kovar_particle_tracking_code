
    imageName = 'e1.tif';
    maskName = 'amask1.tif';
    smoothingFactor = 40;
    markerSize = 5;

    in = readMultiFrameTiff(imageName);
    numFrames = size(in,3);
    mask = imread(maskName);

    [fMean fDen pDen MT] = measureKFParticlesInMovie(in,mask,1800,3,1);

    fMean = smoothdata(fMean,'gaussian',smoothingFactor);
    figure;
    plot(1:numFrames,fMean);
    xlabel('Mean Particle Fluorescence','FontSize',12);

    fDen = smoothdata(fDen,'gaussian',smoothingFactor);
    figure;
    plot(1:numFrames,fDen);
    xlabel('Mean Fluorescence Density','FontSize',12);

    pDen = smoothdata(pDen,'gaussian',smoothingFactor);
    figure;
    plot(1:numFrames,pDen);
    xlabel('Mean Particle Density','FontSize',12);

    showKFParticles(in,MT,markerSize);

    