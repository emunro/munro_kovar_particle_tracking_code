    

    % specify the name of the movie file
    imageName = 'e1.tif';
    
    % specify a particular frame
    frame = 1;

    % name of mask file
    maskName = 'amask1.tif';

    in = imread(imageName,frame);
    mask = imread(maskName);

    [fMean fDen pDen MT] = measureKFParticlesInFrame(in,mask,1800,3,1,1);
   