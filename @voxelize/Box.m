function [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = Box(obj,P,R)
% Box: In order to reduce the voxelization time, a cube surrounding 
%      an ellipsoid or sphere is selected as the voxelization region.
% Input:
%   obj: instantiation of Class:voxelize
%   P:   the center of shpere or ellip for voxelizing, [X,Y,Z]
%   r:   the radius of shpere or ellip for voxelizing
% Output：
%   xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp: 
%      the voxel coordinates of the edges of voxelized cubes.
% written by Wangjiahao

[Nx,Ny,Nz] = obj.dim;

[xBoxLow,yBoxLow,zBoxLow] = obj.XYZ2xyz(P(1)-R,P(2)-R,P(3)-R);
[xBoxUp, yBoxUp, zBoxUp ] = obj.XYZ2xyz(P(1)+R,P(2)+R,P(3)+R);

xBoxLow = max(xBoxLow,1); xBoxUp = min(xBoxUp,Nx);
yBoxLow = max(yBoxLow,1); yBoxUp = min(yBoxUp,Ny);
zBoxLow = max(zBoxLow,1); zBoxUp = min(zBoxUp,Nz);

