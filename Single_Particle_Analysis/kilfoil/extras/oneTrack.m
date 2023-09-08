function res = oneTrack(frms,p,index)

tmp = p(:,4);
traj = p(tmp==index,1:3);
traj = round(traj);
nT = length(traj);
n = traj(nT,3)-traj(1,3);
offset = traj(1,3)-1;
res = zeros([size(frms,1),size(frms,2),3,n*2],'uint16');


for i = 1:n
   res(:,:,1,i) = frms(:,:,i+offset)*135;
   res(:,:,3,i) = frms(:,:,i+offset)*135;
end
offset = offset+n;
for i = 1:n
   res(:,:,1,i+n) = frms(:,:,i+offset)*135;
   res(:,:,3,i+n) = frms(:,:,i+offset)*135;
end
for i = 1:nT
    res(traj(i,2),traj(i,1),2,(traj(i,3)-traj(1,3)+1)) = 65000;
end
end

   
