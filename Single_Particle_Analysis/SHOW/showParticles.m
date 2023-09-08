function [ ] = showParticles(tifname,trks, markerSize, labelParticles, outputfilename)
%   Draws tracked particles as colored circles onto the original image sequence from which the trajectories 
%   were derived. It is assumed that neither the image sequence, nor the trajectories
%   have been transformed in any way (e.g. rotated and translated).
% 
%   Inputs:  

%       tifname: the name of the multiframe tif file.  This file must be in
%       the current working directory

%       trks:  An array of particle trajecotries in "simple" format

%       markerSize:  radius of circles

%       labelParticles:  if 1, add text numbers next to each particle

%       outputfilename:  the name of the outputfile
%
%   Output:
%
%   a quicktime movie called particles.mp4
%   in which particles are drawn as colored circles over the original data.
%   The color of the circle indicates the status of the trajectory:
%
%      blue = bir with the name 'particlesth
%      yellow = death
%      red = continue
%      green = split
%      magenta = merge


    nTrks = length(trks);
    in = readMultiFrameTiff(tifname);
    xaxis = size(in,1);
    yaxis = size(in,2);
    nFrames = size(in,3);

    iMax = mean(max(max(in)));
    iMin = mean(min(min(in)));

    fMax = max([trks.last]);
    fMin = min([trks.first]);

    fig = figure;
    fig.InnerPosition = [100 100 xaxis yaxis];
    axes('Position',[0 0 1 1]);

    % create the video writer with 30 fps
    writerObj = VideoWriter(outputfilename,'MPEG-4');
    writerObj.FrameRate = 30;

    % open the video writer
    open(writerObj);


    for i = fMin:fMax
        %clf;
        imshow(in(:,:,i),[iMin iMax]); 
        axis image;
        hold on;
        for iTrk = 1:nTrks
            if trks(iTrk).first == i
                if strcmp(trks(iTrk).origin,'birth')
                   plot(trks(iTrk).x(1),trks(iTrk).y(1),'bo','MarkerSize',markerSize); % birth
                else
                    if strcmp(trks(iTrk).origin,'merge')
                       plot(trks(iTrk).x(1),trks(iTrk).y(1),'mo','MarkerSize',markerSize); % merge
                    else
                       plot(trks(iTrk).x(1),trks(iTrk).y(1),'go','MarkerSize',markerSize); % split
                    end              
                end
                if labelParticles
                    text(trks(iTrk).x(1),trks(iTrk).y(1),num2str(iTrk), 'Color', 'g');
                end
            end
            if i>trks(iTrk).first &&  i<trks(iTrk).last
                plot(trks(iTrk).x(i-trks(iTrk).first+1),trks(iTrk).y(i-trks(iTrk).first+1),'yo','MarkerSize',markerSize);
                if labelParticles
                    text(trks(iTrk).x(i-trks(iTrk).first+1),trks(iTrk).y(i-trks(iTrk).first+1),num2str(iTrk), 'Color', 'g');
                end
            end            
            if trks(iTrk).last == i

                if strcmp(trks(iTrk).fate,'death')
                   %plot(trks(iTrk).x(trks(iTrk).lifetime),trks(iTrk).y(trks(iTrk).lifetime),'yo','MarkerSize',markerSize);
                else
                    if strcmp(trks(iTrk).fate,'merge')
                       plot(trks(iTrk).x(trks(iTrk).lifetime),trks(iTrk).y(trks(iTrk).lifetime),'mo','MarkerSize',markerSize); % merge
                    else
                       plot(trks(iTrk).x(trks(iTrk).lifetime),trks(iTrk).y(trks(iTrk).lifetime),'go','MarkerSize',markerSize); % split
                    end              
                end
                if labelParticles
                    text(trks(iTrk).x(trks(iTrk).lifetime),trks(iTrk).y(trks(iTrk).lifetime),num2str(iTrk), 'Color', 'g');
                end
            end
            
        end
        pause(0.01);
        frame = getframe();
        writeVideo(writerObj, frame);
        hold off;
   end

   % close the writer object
   close(writerObj);
 

