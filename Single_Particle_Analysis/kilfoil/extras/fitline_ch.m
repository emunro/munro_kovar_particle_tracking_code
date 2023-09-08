% fitline.m
% routine to fit a line y = A + Bx to data sets [x], [y]
% also returns uncertainties in A, B (based on fit)
% ignores uncertainties in x, y
% IF plotopt==1, plot the points, and the line
% Can omit third argument (plotopt); then will not plot
%
% Raghuveer Parthasarathy
% modified 23 March 2007

function [A sigA B sigB] = fitline_ch(x, y, plotopt)

if (length(x) ~= length(y))
   disp('Error!  x, y are not the same size!')
   junk = input('Recommend Control-C to abort. [Enter]');
end

N = length(x);

% Least squares linear fit: y = A + Bx
sx = sum(x);
sxx = sum(x.*x);
sy = sum(y);
syy = sum(y.*y);
sxy = sum(x.*y);
D = N*sxx - (sx*sx);
A = (sxx*sy - sx*sxy)/D;
B = (N*sxy - sx*sy)/D;

% Uncertainties
sigy = sqrt(sum((y - A - B*x).*(y-A-B*x))/(N-2));
sigA = sigy*sqrt(sxx/D);
sigB = sigy*sqrt(N/D);

if (nargin > 2)  % Are there more than two inputs to the function?
   if plotopt==1
       figure; plot(x, A + B*x, '-', 'Color', [0.5 0.5 0.5]);
       hold on;
       plot(x, y, 'ko');
   end
end