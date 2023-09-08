function [totalStep, radialStep, bigstep, largesteps] = TotalStepDist(objs_link,tau)

% This function returns the total step size distribution for set of particle
% tracks by finding the step size (in pixels) of each track for a frame delay of
% 1.
%
%
% Chris Harland
% 2011.02.25
%


totalStep = [];
radialStep = [];
bigstep = [];
largesteps = [];
utrk = unique(objs_link(6,:));
for i = utrk
    singobjs = objs_link(1:5,objs_link(6,:)==i);
    xtmp = nanpad(singobjs(1,:), singobjs(5,:));
    ytmp = nanpad(singobjs(2,:), singobjs(5,:));
    try
        dx = xtmp(tau+1:end)-xtmp(1:end-tau);
        dy = ytmp(tau+1:end)-ytmp(1:end-tau);
        dr = sqrt(dx.^2+dy.^2);
        frames = (min(singobjs(5,:)):max(singobjs(5,:))-1);
        tmp = frames(dx>=(0.1/0.1) | dy>=(0.1/0.1));
        frames = tmp(~isnan(tmp));
        frames = [i*ones(1,length(frames)); frames];
    catch ME
        fs = sprintf('Track %d is not long enough for delay %d',utrk,tau);
        disp(fs); 
    end
%     dx = singobjs(1,2:end)-singobjs(1,1:end-1);
%     dy = singobjs(2,2:end)-singobjs(2,1:end-1);
    largesteps = [largesteps frames];
    bigstep = [bigstep [ones(1,length(tmp))*i; tmp]];
    totalStep = [totalStep dx dy];
    radialStep = [radialStep dr];
end
totalStep = totalStep(~isnan(totalStep));
radialStep = radialStep(~isnan(radialStep));