function bool_mat = nippleVoxelize(obj,nippleP,nippleRad,nippleLen)

t = 3;
[Nx,Ny,Nz] = obj.dim;
bool_mat = zeros(Nx,Ny,Nz,'logical');
nPX = nippleP(1); nPY = nippleP(2); nPZ = nippleP(3);
[xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = boxNipple(obj,nippleP,nippleRad,nippleLen);
[y,x,z] = meshgrid(yBoxLow:yBoxUp, xBoxLow:xBoxUp, zBoxLow:zBoxUp);
[X,Y,Z] = xyz2XYZ(obj,x,y,z);
X = X-nPX; Y = Y-nPY; Z = Z-nPZ;
bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
          (sqrt(Y.^2+Z.^2)/nippleRad).^t+(abs(X)/nippleLen).^t <= 1;
end

function [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = boxNipple(obj,P,nippleRad,nippleLen)
[Nx,Ny,Nz] = obj.dim;

[xBoxLow,yBoxLow,zBoxLow] = obj.XYZ2xyz(P(1)-nippleLen,P(2)-nippleRad,P(3)-nippleRad);
[xBoxUp, yBoxUp, zBoxUp ] = obj.XYZ2xyz(P(1)+nippleLen,P(2)+nippleRad,P(3)+nippleRad);

xBoxLow = max(xBoxLow,1); xBoxUp = min(xBoxUp,Nx);
yBoxLow = max(yBoxLow,1); yBoxUp = min(yBoxUp,Ny);
zBoxLow = max(zBoxLow,1); zBoxUp = min(zBoxUp,Nz);
end
