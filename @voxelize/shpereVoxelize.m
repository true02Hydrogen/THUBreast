function [bool_mat,box] = shpereVoxelize(obj,P,R)
% ShpereVoxelize2:根据球的球心坐标和半径,将球体素化;
%                 该方法在球表面加了周期纹理，但非perlin噪声
% Input:
%   obj 为实例化voxelize()
%   P   球心坐标P点
%   R   球半径
% Output：
%   bool_mat:体素化目标区域的逻辑矩阵
% written by Renli; modified by Wangjiahao

X0 = P(1); Y0 = P(2); Z0 = P(3);
%球判断范围边界对应的体素编号值
[xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = Box(obj,P,R);
box = [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp];
% 球心点对应的体素值
[x0,y0,z0]=XYZ2xyz(obj,X0,Y0,Z0);
% （x,y,z）为体素模型下的所有序号坐标
[y,x,z] = meshgrid(yBoxLow:yBoxUp, xBoxLow:xBoxUp, zBoxLow:zBoxUp);
x = x-x0;  y = y-y0;  z = z-z0;
[phi,theta,r] = cart2sph(x,y,z);
clear x y z;

freq = 5;
xp = (phi+pi)/(2*pi)*freq;
kxi = 1/2-cos(theta+pi/2)/2;
yp = (kxi)*freq;
clear phi theta kxi;

[uxmat,uymat] = randxymat(freq+2,freq+2);
zp1=perlinNoise(xp,yp,uxmat,uymat); clear uxmat uymat;

[uxmat2,uymat2] = randxymat(2*freq+2,2*freq+2);
zp2=perlinNoise(xp*2,yp*2,uxmat2,uymat2); clear uxmat2 uymat2;
weight = 0.5;
zp = zp1 + zp2*weight; clear zp1 zp2;

bool_mat = (r <= (0.8+0.2*zp)*R*obj.Res);
