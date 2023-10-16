function breast = creAmpul(v,breast,nippleR,nippleP)
% branchPoint: based on the former point and the startPoint\theta\phi\h\ 
% of duct branch, determine the end point of duct branch.
% Input:
%   v: instantiation of Class:voxelize
%   breast: breast matrix, Nx*Ny*Nz
%   nippleR: the radius of nipple
%   nippleP: the position of nipple, [X,Y,Z]
% Output：
%   breast: breast matrix, added ampullae, Nx*Ny*Nz
% written by  Wangjiahao

t = tissue();
nAmpul = 7; % number of ampulla lactifera
r0 = 2; % max radius of ampulla
ampulStartPYZ = ductBranch.startPSamp(nAmpul,r0,nippleP,nippleR);
ampulStartPX = repmat(nippleP(1)-4,size(ampulStartPYZ,1),1);
ampulStartP = cat(2,ampulStartPX,ampulStartPYZ);
[Nx,Ny,Nz] = v.dim();
bool_ampul = zeros([Nx,Ny,Nz],'logical');
for i = 1:size(ampulStartP,1)
    startP = ampulStartP(i,:);
    r = 1 + rand;
    h = 4 + 2*rand;
    endP = ampulStartP(i,:) + [h,0,0];
    [ampulla,box] = v.cylinderVoxelize(startP,endP,r);
    xBoxLow = box(1); xBoxUp = box(2);
    yBoxLow = box(3); yBoxUp = box(4);
    zBoxLow = box(5); zBoxUp = box(6);
    bool_ampul(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
        bool_ampul(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) | ampulla;
end
breast(bool_ampul) = t.ampul; 
end

