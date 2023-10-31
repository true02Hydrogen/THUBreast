function [bool_mat,box] = shpereVoxelize(obj,P,R)
% ShpereVoxelize:The spheroid is primed according to its centroid coordinates and radius.
%    The spheroid is primed according to its centroid coordinates and radius. 
%    This method adds periodic texture to the surface of the ball, but it is not perlin noise
% Input:
%   obj : initialize voxelize()
%   P   : Spherical point P
%   R   : radius of sphere
% Output：
%   bool_mat : The logical matrix of the voxelized target region
% written by Wangjiahao.

X0 = P(1); Y0 = P(2); Z0 = P(3);
% The sphere determines the voxel number value corresponding to the range boundary
[xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = Box(obj,P,R);
box = [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp];
% The voxel value corresponding to the center of the sphere
[x0,y0,z0]=XYZ2xyz(obj,X0,Y0,Z0);
% (x,y,z) are all ordinal coordinates under the voxel model
[y,x,z] = meshgrid(yBoxLow:yBoxUp, xBoxLow:xBoxUp, zBoxLow:zBoxUp);
x = x-x0;  y = y-y0;  z = z-z0;
[phi,theta,r] = cart2sph(x,y,z);

freq = 5;
[uxmat,uymat] = randxymat(freq+2,freq+2);
[uxmat2,uymat2] = randxymat(2*freq+2,2*freq+2); 
xp = (phi+pi)/(2*pi)*freq;
kxi = 1/2-cos(theta+pi/2)/2;
yp = (kxi)*freq;
zp1=perlinNoise(xp,yp,uxmat,uymat);
zp2=perlinNoise(xp*2,yp*2,uxmat2,uymat2);
weight = 0.5;
zp = zp1 + zp2*weight;

bool_mat = (r <= (0.8+0.2*zp)*R*obj.Res);
