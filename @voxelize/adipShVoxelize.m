function bool_mat = adipShVoxelize(obj,bool_adip,nAdip,R)
% adipElVoxelize: add adipose shpere to adipose area
% Input:
%   obj: instantiation of Class:voxelize
%   bool_adip: adipose logical area, Nx*Ny*Nz
%   R: the radius of adipose shpere
% Output：
%   bool_mat: adipose shpere logical area sampled , Nx*Ny*Nz
% written by Renli; modified by Wangjiahao

[Nx,Ny,Nz] = obj.dim;
bool_mat = zeros(Nx,Ny,Nz,'logical');
P = AdipSample(obj,bool_adip,nAdip);
for i = 1:size(P,1)
    Pi = P(i,:);
    X0 = Pi(1); Y0 = Pi(2); Z0 = Pi(3);
    % 球判断范围边界对应的体素编号值
    [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = Box(obj,Pi,R);
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
    bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
        bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)|(r <= (0.8+0.2*zp)*R*obj.Res);
end
end

function adipCenter = AdipSample(obj,bool_adip,nAdip)
% AdipSample: sample nAdip adipose shpere centers from adipose logical area
% Input:
%   obj: instantiation of Class:voxelize
%   bool_adip: adipose logical area, Nx*Ny*Nz
%   nAdip: the number of adipose shpere
% Output：
%   adipCenter: all adipose shpere centers, nAdip*3
% written by Renli; modified by Wangjiahao

nTotal = find(bool_adip);
rndInd = randi(length(nTotal),[nAdip,1]);
[px,py,pz] = ind2sub(size(bool_adip),nTotal(rndInd));
[PX,PY,PZ] = obj.xyz2XYZ(px,py,pz);
adipCenter = [PX,PY,PZ];
end
