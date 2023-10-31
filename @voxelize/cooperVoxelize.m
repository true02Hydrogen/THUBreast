function bool_mat = cooperVoxelize(obj,bool_adip,direc)
% cooperVoxelize: add Cooper to adipose area
% Input:
%   obj: instantiation of Class:voxelize
%   bool_adip: adipose logical area, Nx*Ny*Nz
%   direc: the direction of an ellipsoid 
% Output：
%   bool_mat: Cooper logical area sampled , Nx*Ny*Nz
% written by Renli; modified by Wangjiahao

[Nx,Ny,Nz] = obj.dim;
bool_mat = zeros(Nx,Ny,Nz,'logical');
P = CooperSample(obj,bool_adip);
numP = size(P,1);
a = rand(numP,1)*7+6;
b = rand(numP,1)*7+6;
c = 30;
for i = 1:numP
    Pi = P(i,:); ai = a(i); bi = b(i) ; ci = c;
    X0 = Pi(1); Y0 = Pi(2); Z0 = Pi(3);
    [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = obj.Box(Pi,c);
    [x0,y0,z0] = obj.XYZ2xyz(X0,Y0,Z0);
    [beta,psi,~] = cart2sph(direc(1)-X0,direc(2)-Y0,direc(3)-Z0);
    psi  = pi/2 -psi;
    beta = pi/2 -beta;
    [y,x,z] = meshgrid(yBoxLow:yBoxUp, xBoxLow:xBoxUp, zBoxLow:zBoxUp);
    xt = -cos(psi)*sin(beta)*(x-x0)-cos(psi)*cos(beta)*(y-y0)+sin(psi)*(z-z0);
    yt =           cos(beta)*(x-x0)-         sin(beta)*(y-y0)                ;
    zt =  sin(psi)*sin(beta)*(x-x0)+sin(psi)*cos(beta)*(y-y0)+cos(psi)*(z-z0);
    [phi,theta,r] = cart2sph(xt/ai,yt/bi,zt/ci);

    freq = 5;
    [uxmat,uymat] = randxymat(freq+2,freq+2);
    [uxmat2,uymat2] = randxymat(2*freq+2,2*freq+2); 
    [uxmat4,uymat4] = randxymat(4*freq+2,4*freq+2);
    [uxmat8,uymat8] = randxymat(8*freq+2,8*freq+2);
    xp = (phi+pi)/(2*pi)*freq; 
    yp = (theta+pi/2)/(pi)*freq; 
    zp1=perlinNoise(xp,yp,uxmat,uymat);
    zp2=perlinNoise(xp*2,yp*2,uxmat2,uymat2);
    zp3=perlinNoise(xp*4,yp*4,uxmat4,uymat4);
    zp4=perlinNoise(xp*8,yp*8,uxmat8,uymat8);
    weight = 0.5;
    zp = zp1 + zp2*weight + zp3*weight^2+ zp4*weight^3;
    
    bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
        bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)|...
        ((r <=(0.8+0.2*zp)*obj.Res)&(r >= 0.95*(0.8+0.2*zp)*obj.Res));% cooper thickness 0.25-0.3mm Graff
end
bool_mat = bool_mat&bool_adip;
end

function cooperCenter = CooperSample(obj,bool_adip)

reserved = 4000;
nTotal = find(bool_adip);
RndInd = randi(length(nTotal),[reserved,1]);
[px,py,pz] = ind2sub(size(bool_adip),nTotal(RndInd));
[PX,PY,PZ] = obj.xyz2XYZ(px,py,pz);
P = NaN(reserved,3);
P(1,:) = [PX(1),PY(1),PZ(1)]; 
counter = 1;
tag = 1;
for i=2:reserved
    tempP=[PX(i),PY(i),PZ(i)];
    for j=1:counter
        if norm(tempP-P(j,:))<26
        tag = 0; 
        break
        end
    end
    if  tag == 1
        counter = counter+1;
        P(counter,:)=tempP;
    else 
       tag = 1;
    end
end
nEffect = length(find(~isnan(P)))/3; 
cooperCenter = P(1:nEffect,:);
end


