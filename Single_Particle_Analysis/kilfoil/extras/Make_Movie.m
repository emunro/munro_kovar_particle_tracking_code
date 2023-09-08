% Make_Movie.m
% This program plays a movie of an image sequence

clear all;
close all;

% Information Display
disp(' ');
disp('*** Make_Movie.m ***');
disp('Suggestion: first change to movie directory, using ');
disp('               "cd [directory in single quotes]", or toolbar.');
disp(' ');

% Load image sequence
loadopt = input('   Enter 1 to choose the last image in the sequence from a dialog box, 0 to type it manually:  ');
if (loadopt==1)
    % dialog box for filename
    [aFileName,aPathName] = uigetfile('*.*', 'Select the last image in the sequence...');
else
    aFileName=input('   Enter the filename of the last image in the sequence:  ','s');
    aPathName = strcat(pwd,'/');
end
temp = imread(strcat(aPathName,aFileName));
Afile = strcat(aPathName, aFileName);

fs = sprintf('  Path Name: %s', aPathName); disp(fs);
fs = sprintf('  File Prefix: %s', aFileName);   disp(fs);

% Various information about the movie/sequence
[dummy, length] = size(aFileName);
base = strcat(aFileName(1:(length - 8)));
NumFrames = str2double(strcat(aFileName((length - 7):(length-4))));
numFormat = '%04d';
if (isnan(NumFrames)),
    NumFrames = str2double(strcat(aFileName((length - 6):(length-4))));
    base = strcat(aFileName(1:(length - 7)));
    numFormat = '%03d';
end


% Number of frames to load
prompt = {'Starting time to load (seconds). Default is 0', ...
    'Ending time to load (seconds)', ...
    'Clip Duration (seconds)'};
dlg_title = 'Time Frame'; num_lines=1;
def     = {'0', '10','100'};   % default values
answer = inputdlg(prompt,dlg_title,num_lines,def);
FramesPerSecond = NumFrames/str2double(answer(3));
if (str2double(answer(1))== 0)
    startN = 1;
else
    startN = str2double(answer(1))*FramesPerSecond;
end
endN = str2double(answer(2))*FramesPerSecond;

% Load image sequence
[h,w]= size(temp);
mov= zeros(h,w,endN); % Initialize for speed
disp('  Loading image sequence (wait for "done" indication) ...');
progtitle = 'Progress in loading images';
progbar = waitbar(0, progtitle);  % will display progress
for i = startN:endN;
    frame = num2str(i, numFormat);
%     [mov(:,:,i),cmap(:,:,i)] = imread(strcat(aPathName, base,frame,'.tif'));
    mov(:,:,i) = imread(strcat(aPathName, base,frame,'.tif'));
    waitbar(i/endN, progbar, strcat(progtitle, ' ...'));
end
close(progbar);
disp('  ...done.');

% bit depth
% Estimate bit depth from frame startN
maxint = max(max(double(mov(:,:,startN))));  % maximal observed intensity in frame startN
bits = ceil(log2(maxint));
prompt = {'Enter the bit-depth of the movie (e.g. 8, 14...); Estimated value given as default',...
     'Auto Level the test image to improve contrast?'};
dlg_title = 'Bit Depth'; num_lines= 1;
def     = {num2str(bits), '0'};  % default values
answer  = inputdlg(prompt,dlg_title,num_lines,def);
bits = str2double(answer(1));
contopt = str2double(answer(2));

% Convert to 8 bit
for i = startN:endN
    if(contopt ==1)
        mov(:,:,i) = ((2^8 - 1)/(maxint)).*mov(:,:,i);
    else
        mov(:,:,i) = ((2^8 - 1)/(2^bits - 1)).*mov(:,:,i);
    end
end

% Create the movie
for i = startN:endN;
    m(i).cdata = uint8(mov(:,:,i));
%     m(i).colormap = uint8(cmap(:,:,i));
    m(i).colormap = gray(2^8);
end

% Play the movie
movie(m,10,FramesPerSecond);
clear all;