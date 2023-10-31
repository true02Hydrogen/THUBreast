function  [bool_mat,box] = cylinderVoxelize(obj,P1,P2,R)
% CylinderVoxelize: voxelize cylinder
% Input:
%   obj: instantiation of Class:voxelize
%   P1:  start point of cylinder
%   P2:  end point of cylinder
%   R:   the radius of cylinder
% Output：
%   bool_mat: cylinder logical area
%   box: [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] 
%        xyz range of logical area
% written by Wangjiahao

v = obj;
X1 = P1(1); Y1 = P1(2); Z1 = P1(3); 
X2 = P2(1); Y2 = P2(2); Z2 = P2(3); 

if X2<=v.Xlower||X2>v.Xupper||Y2<=v.Ylower||Y2>v.Yupper ...
            ||Z2<=v.Zlower||Z2>v.Zupper
    bool_mat = 0;
    disp("cylinder beyond the voxel matrix boundary");
    return
else         
    [x1,y1,z1] = v.XYZ2xyz(X1,Y1,Z1);

    [beta,psi,h] = cart2sph(X2-X1,Y2-Y1,Z2-Z1);
    psi  = pi/2 -psi;
    beta = pi/2 -beta;

    [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = BoxCylinder(v,P1,P2,R);
    box = [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp];
    [y,x,z] = meshgrid(yBoxLow:yBoxUp, xBoxLow:xBoxUp, zBoxLow:zBoxUp);

    xt = -cos(psi)*sin(beta)*(x-x1)-cos(psi)*cos(beta)*(y-y1)+sin(psi)*(z-z1);
    yt =           cos(beta)*(x-x1)-         sin(beta)*(y-y1)                   ;
    zt =  sin(psi)*sin(beta)*(x-x1)+sin(psi)*cos(beta)*(y-y1)+cos(psi)*(z-z1);
    [~,r,zCyl] = cart2pol(xt,yt,zt);
    bool_mat = (r <= R*v.Res)&(zCyl >= 0)&(zCyl <= h*v.Res);
end
end

function [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = BoxCylinder(obj,P1,P2,R)
% BoxCylinder: the range of cube for voxelizing
% Input:
%   obj: instantiation of Class:voxelize
%   P1:  start point of cylinder
%   P2:  end point of cylinder
%   R:   the radius of cylinder
% Output：
%   [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp]: xyz range of logical area
% written by Wangjiahao.
[Nx,Ny,Nz] = obj.dim;

xmin = min(P1(1),P2(1));  ymin = min(P1(2),P2(2));  zmin = min(P1(3),P2(3));
xmax = max(P1(1),P2(1));  ymax = max(P1(2),P2(2));  zmax = max(P1(3),P2(3));

[xBoxLow,yBoxLow,zBoxLow] = obj.XYZ2xyz(xmin-R,ymin-R,zmin-R);
[xBoxUp, yBoxUp, zBoxUp ] = obj.XYZ2xyz(xmax+R,ymax+R,zmax+R);

xBoxLow = max(xBoxLow,1); xBoxUp = min(xBoxUp,Nx);
yBoxLow = max(yBoxLow,1); yBoxUp = min(yBoxUp,Ny);
zBoxLow = max(zBoxLow,1); zBoxUp = min(zBoxUp,Nz);
end

