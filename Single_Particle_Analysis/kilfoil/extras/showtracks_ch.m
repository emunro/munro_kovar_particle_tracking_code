% showtracks.m
%
% Program to plot the tracks of found objects.
% Colors the tracks with increasing brightness proportional to "frame"
%
% Input:
%    objs = object matrix, in which row 6 contains the "track ids" for
%           the tracks found by (e.g.) nnlink_rp.m
%    h (optional) = the handle to a figure window in which to draw the
%        tracks.  If h is not supplied, create a new figure window.
%
% Raghuveer Parthasarathy
% 23 April, 2007

% Modified by Chris Harland
% 03 May, 2007
% rearranged the program to work with the Crocker tracking software

% Complete re-write by CWH
% Now does a full image export of each frame with drawn tracks

function showtracks_ch(objs, Nmin, labelopt, im)

firstdir = pwd;
if Nmin>0
    % Get all tracks longer than Nmin
    trlength = find_long_track(objs);
    trlength = trlength(:,trlength(2,:)>=Nmin);
    % pause;
    % Reduce the objs array to only these objects
    goodind = ismember(objs(6,:),trlength(1,:));
    objs = objs(:,goodind);
end

if nargin<3.1
    % Load the Corresponding image sequence
    im = TIFFseries();
end

close all
cd TrackMovie


% Auto Level the images and add the positions
% h = figure;
% set(gca,'position',[0 0 1 1]);
for i = 1:size(im,3)
    % Find all the tracks that have a prescence this frame
    objstemp = objs(:,objs(5,:)==i);
%    large = largesteps(1,largesteps(2,:)==i);
 %   large = unique(large);
  %  largeobjs = objstemp(:,ismember(objstemp(6,:),large));
    axes('position',[0 0 1 1]); imagesc(im(:,:,i)); colormap gray;
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 4 3]);
    hold on
    plot(objstemp(1,:),objstemp(2,:),'o','MarkerEdgeColor','none','MarkerFaceColor','y',...
        'MarkerSize',2);
%    plot(largeobjs(1,:),largeobjs(2,:),'o','MarkerEdgeColor','none','MarkerFaceColor','r',...
 %       'MarkerSize',2);
   if labelopt
       for j = 1:length(objstemp(1,:))
           text(objstemp(1,j)+1,objstemp(2,j)+1,int2str(objstemp(6,j)),'FontSize',8,...
               'color','r');
       end
    end
    % Check if this is a new track or the last frame of a current track
%     utrk = unique(objs(6,:));
%     for j = utrk
%         singobjs = objs(:,objs(6,:)==j);
%         if min(singobjs(5,:)) == i
%             singx = singobjs(1,singobjs(5,:)==i);
%             singy = singobjs(2,singobjs(5,:)==i);
%             plot(singx,singy,'o','MarkerEdgeColor','none','MarkerFaceColor','g',...
%                 'MarkerSize',2);
%             if labelopt
%                 text(singx+1,singy+1,int2str(singobjs(6,1)),'FontSize',8,...
%                     'color','y');
%             end
%         elseif max(singobjs(5,:)) == i
%             singx = singobjs(1,singobjs(5,:)==i);
%             singy = singobjs(2,singobjs(5,:)==i);
%             plot(singx,singy,'o','MarkerEdgeColor','none','MarkerFaceColor','r',...
%                 'MarkerSize',2);
%             if labelopt
%                 text(singx+1,singy+1,int2str(singobjs(6,1)),'FontSize',8,...
%                     'color','y');
%             end
%         end
%     end
    fs = sprintf('TrackFrame%04d',i);
    saveas(gcf,fs,'png');
    hold off
end
% Plot Candidate Locations on the image

% Save the result
cd(firstdir);
end
