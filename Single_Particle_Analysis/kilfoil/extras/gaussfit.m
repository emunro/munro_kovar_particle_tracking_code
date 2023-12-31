% gaussfit.m
%
% simple gaussian fit, using polyfit and logarithms
% no uncertainty analysis
% 1D arrays x, y
% fit to form: y = A*exp(-(x-x0)^2 / (2*sigma^2))
% * max. value of y must be positive* -- since uses logs to calc. gaussian
% Consider only data > threshold*ymax -- input parameter "threshold" -- if
%    omitted, use threshold = 0.2  Threshold ensures that fit is not
%    dominated by tails of the Gaussian
%
% Raghuveer Parthasarathy 10 Nov. 06
% last modified 6 June, 2007

function [A, x0, sigma] = gaussfit(x, y, threshold)

ymax = max(y(:));
if (ymax < 0.0)
    disp('gaussfit.m:  ERROR! ymax must be positive!');
    disp('Press Control-C');
    pause
end
if (nargin < 3)
    threshold = 0.2;
end

if (length(x) ~= length(y))
    disp('Error -- length(x) ~= length(y).  Press Control-C');
    pause;
end

% -- Eliminate small or non-positive y-values
x = x(y >= threshold*ymax);
y = y(y >= threshold*ymax);

logy = log(y);
p = polyfit(x, logy, 2);
a = p(1);
b = p(2);
c = p(3);

sigma = sqrt(-1.0 / 2.0 / a);
x0 = b*sigma*sigma;
A = exp(c + x0*x0/2/sigma/sigma);
