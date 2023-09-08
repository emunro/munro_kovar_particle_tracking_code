% im_seq_cands.m
%
% This function outputs a series of pngs with candidate speckle locations
% plotted on the original image.
%
% Chris Harland
% 2010.11.08

function im_seq_cands()

firstdir = pwd;

% Choose the actinflow.mat file
[CandsName,CandsPathName] = uigetfile('*.mat', 'Select the candidate mat file...');

load(CandsName);

% Load the Corresponding image sequence
im = TIFFseries();
cd tack/cands;
% Auto Level the images and add the positions
h = figure;
set(gca,'position',[0 0 1 1]);
for i = 1:size(im,3)
%     tempim = double(im(:,:,i));
%     tempim = (tempim./max(max(tempim)))*((2^16)-1);
    
    pos = actflow(i).p;
    
%     imshow(tempim); colormap gray;
    imagesc(im(:,:,i)); colormap gray;
    hold on
    plot(pos(2,:),pos(1,:),'o','MarkerEdgeColor','none','MarkerFaceColor','r',...
        'MarkerSize',1);
    fs = sprintf('cands%04d',i);
    saveas(gcf,fs,'png');
    hold off
end
close(h);
% Plot Candidate Locations on the image

% Save the result
cd(firstdir);
end