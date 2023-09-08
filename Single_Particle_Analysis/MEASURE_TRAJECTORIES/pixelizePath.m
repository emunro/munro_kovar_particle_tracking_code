function pixelList = pixelizePath(smoothedPath,pathWidth,initialPosition)
%pixelizePath:  Take a path representing a smoothed trajectory an produce
%and array of pixel positions within a region of interest centerd on the
%soothed path and extending orthogally by a fixed pixel width on either
%side

% Inputs:

% smoothedPath = a 2 x N array containing x and y positions at the N points
% along the smoothed path

% pathWidth         = the width of the path in pixels.  

% initialPosition   = inital position in arclength from the beginning of the smoothed path

% Outputs:
%
% pixelList = a 2 x pathWidth x pixelLength array of x and y pixel values,
%               where pixelLength is the legnth of the path in pixels.


[uVecs,segLengths] =  getDisplacements(smoothedPath);
    
nVecs = vertcat(uVecs(2,:),-uVecs(1,:));
nSegs = length(segLengths);
totalL = sum(segLengths);

if nargin == 3
    s = initialPosition;
else
    s = 0.5; 
end

pixelLength = floor(totalL-s) + 1;


pixelList = zeros(2,pathWidth,pixelLength);
orthoDisplacements = -(pathWidth-1)/2:(pathWidth-1)/2;
j = 1;
for i = 1:nSegs
    spread = nVecs(:,i)*orthoDisplacements;
    while s < segLengths(i)
        pixels = smoothedPath(:,i) + uVecs(:,i)*s;
        pixels = pixels + spread;
        pixelList(:,:,j) = pixels;
        j = j+1;
        s = s+1;
    end
    s = s - segLengths(i);
end
    







  



