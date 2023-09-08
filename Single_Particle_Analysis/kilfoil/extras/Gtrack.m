function [res objs] = Gtrack(im,noise,featsize, thresh)

pk = [];
cnt = [];
param.mem = 3;
param.good = 10;
param.dim = 2;
param.quiet = 0;

for i = 1:size(im,3)
   imtemp = bpass(im(:,:,i),noise,featsize);
   pktemp = pkfnd(imtemp,thresh,featsize+1);
   cnttemp = cntrd(imtemp,pktemp,featsize+1,0);
   cnt = [cnt; [cnttemp ones(length(cnttemp),1)*i]];
end
poslist = cnt(:,[1 2 5]);
res = track(poslist, featsize, param);
objs = convert_to_objs(res);
end