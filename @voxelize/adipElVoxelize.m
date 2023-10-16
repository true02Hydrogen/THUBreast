function [breast,actualGlaFrac] = adipElVoxelize(obj,targetGlaFrac,breast,nippleP,gcy,gcz)
% adipElVoxelize: add adipose ellipsoid to fiberglandular area
% Input:
%   obj: instantiation of Class:voxelize
%   targetGlaFrac: target glandular fraction range:(0,100]
%   breast: breast matrix, Nx*Ny*Nz
%   nippleP: nipple position, [X,Y,Z]
% Output：
%   breast: breast matrix, Nx*Ny*Nz
%   actualGlaFrac: actual glandular fraction
% written by by Wangjiahao

minArgs=4;
maxArgs=6;
narginchk(minArgs,maxArgs);

t = tissue();
tempBreast = breast;
tempBreast(tempBreast == t.fgFiber) = t.fgAdip;
minGlaFrac = t.VBD(tempBreast);
if targetGlaFrac == 100 
    actualGlaFrac = targetGlaFrac;
    return  
elseif targetGlaFrac <= minGlaFrac
    actualGlaFrac = minGlaFrac;
    breast = tempBreast;
    return
end

reserved = 100000;
Vfat = tissue.targetVfat_vbd(obj,breast,targetGlaFrac); %目标vbd下 纤维腺体区其中脂肪体积
if Vfat < 0
    disp(' cannot obtain the target VBD !!!');
    return
end
nVoxelfat = ceil(Vfat*(obj.Res)^3); %纤维腺体区其中脂肪体素个数
a = rand(reserved,1)*2+1; % a,b = 1~3；
b = a;
c = 3*a;      % c = 3~9
theta = rand(reserved,1)*30*pi/180;    % theta[0,30° ]
phi   = rand(reserved,1)*180*pi/180;   % phi  [0,180°]
volumeEl = 4/3*pi*a.*b.*c;
cumVolumeEl = cumsum(volumeEl);
minElNum = find(cumVolumeEl<Vfat, 1, 'last' );% min ellip number 
if isempty(minElNum)
    minElNum = 1; 
end
bool_fibGla = (breast == t.fgFiber|breast == t.dTree | breast == t.lob);
bool_dTree = (breast == t.dTree | breast == t.lob);

% 脂肪球的抽样分布
bool_samp = ~bool_dTree&bool_fibGla;
raf_gauss = gauss_RA_dis([size(bool_samp,2),size(bool_samp,3)],targetGlaFrac);
raf_homo = x_RA_dis([size(bool_samp,2),size(bool_samp,3)],targetGlaFrac);
M_sup = max(raf_gauss(:)./raf_homo(:));
distribution = raf_gauss./raf_homo/M_sup;

bool_mat = zeros(size(breast),'logical');

P = elAdipSample(obj,bool_samp,reserved);
direc = nippleP;
if nargin < 6
    gcy = nippleP(2); gcz = nippleP(3);
end

elCount = 0;  gcy=Y2y(obj,gcy); gcz=Z2z(obj,gcz);
for i = 1:reserved
    Pi = P(i,:);
    X0 = Pi(1); Y0 = Pi(2); Z0 = Pi(3);
    % 椭球中心对应的体素值
    [x0,y0,z0]=XYZ2xyz(obj,X0,Y0,Z0);

    cdist = max(ceil(norm([y0-gcy,z0-gcz])/5),1);
    if rand > distribution(cdist)
        continue;
    end
    elCount = elCount+1;
    ai = a(elCount); %椭圆半轴长A、B=1~3；
    bi = ai;
    ci = 3*ai;      %椭圆径向半轴长C=3~9
    thetai = theta(elCount);    % theta在0~30°间变化
    phii   = phi(elCount);   % phi在0~180°间变化
    %椭球的判断范围（正方体）边界对应的体素编号值
    [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = Box(obj,Pi,ci);

    [beta,psi,~] = cart2sph(direc(1)-X0,direc(2)-Y0,direc(3)-Z0);
    psi  = pi/2 - psi;
    beta = pi/2 - beta;
    [y,x,z] = meshgrid(yBoxLow:yBoxUp, xBoxLow:xBoxUp, zBoxLow:zBoxUp);
    rot1 = ...
    [-cos(thetai)*sin(phii)   -cos(thetai)*cos(phii)    sin(thetai);...
      cos(phii)               -sin(phii)                0;...
      sin(thetai)*sin(phii)    sin(thetai)*cos(phii)    cos(thetai)];
    rot2 = ...          
    [-cos(psi)*sin(beta)    -cos(psi)*cos(beta)     sin(psi);...
      cos(beta)             -sin(beta)              0;...
      sin(psi)*sin(beta)     sin(psi)*cos(beta)     cos(psi)];
    rotMat = rot1*rot2;
    xt = rotMat(1,1)*(x-x0)+rotMat(1,2)*(y-y0)+rotMat(1,3)*(z-z0);
    yt = rotMat(2,1)*(x-x0)+rotMat(2,2)*(y-y0)+rotMat(2,3)*(z-z0);
    zt = rotMat(3,1)*(x-x0)+rotMat(3,2)*(y-y0)+rotMat(3,3)*(z-z0);
    [phit,thetat,r] = cart2sph(xt/ai,yt/bi,zt/ci);
    
    freq = 5;
    [uxmat,uymat] = randxymat(freq+2,freq+2);
    [uxmat2,uymat2] = randxymat(2*freq+2,2*freq+2); 
    xp = (phit+pi)/(2*pi)*freq;
    kxi = 1/2-cos(thetat+pi/2)/2;
    yp = (kxi)*freq;
    zp1=perlinNoise(xp,yp,uxmat,uymat);
    zp2=perlinNoise(xp*2,yp*2,uxmat2,uymat2);
    weight = 0.5;
    zp = zp1 + zp2*weight;

    if elCount < minElNum
        bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
        bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)|...
        (r <=(0.8+0.2*zp)*obj.Res);
    elseif elCount == minElNum
        bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
        bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)|...
        (r <=(0.8+0.2*zp)*obj.Res);
        bool_mat = bool_mat&bool_samp;
        tempVoxelFat = size(find(bool_mat),1);

        if tempVoxelFat > nVoxelfat
            breast(bool_mat) = t.fgAdip;
            actualGlaFrac = t.VBD(breast);
            break
        end
    else
        tempVoxelFat = tempVoxelFat + size(find((bool_samp(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)...
        &~bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)&r <=(0.8+0.2*zp)*obj.Res)),1);
       
        bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
        bool_mat(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)|...
        bool_samp(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)&...
        (r <=(0.8+0.2*zp)*obj.Res);

        if tempVoxelFat > nVoxelfat
            breast(bool_mat) = t.fgAdip;
            actualGlaFrac = t.VBD(breast);
            break
        end
    end
end
end

function elAdipCenter = elAdipSample(obj,bool_samp,nAdip)
nTotal = find(bool_samp);
rndInd = randi(length(nTotal),[nAdip,1]); 
[px,py,pz] = ind2sub(size(bool_samp),nTotal(rndInd));
[PX,PY,PZ] = obj.xyz2XYZ(px,py,pz);
elAdipCenter = [PX,PY,PZ];
end

function y = xgauss(bin)
% 生成0-1之间的x*Gauss的密度分布，sigma根据Hernandez 2015得到
sigma = 0.135*2;
interval = 1/bin; %bin必须比抽样平面的半维度要大，500比较合适;
x = interval/2:interval:1-interval/2;
y = x.*exp(-x.^2/(2*sigma^2));% 此处修改函数可以得到任意函数分布的抽样！
y = y/sum(y); % normlize
y = y';
end

function rad = sampDis(disy,n)
% 根据任意分布disy,抽相对半径 relative radial
normcumy = cumsum(disy);
r = rand(n,1);
rad = zeros(n,1,'double');
for i = 1:n
    rad(i) = find(normcumy>r(i),1)/length(disy);
end
end

function [raf,raf2] = x_RA_dis(dim,targetGlaFrac)
samp_model = ones([dim(1),dim(2),10],'uint8');
[y,x,~] = meshgrid(1:dim(2), 1:dim(1), 1:10);
c = [ceil(dim(1)/2),ceil(dim(2)/2)];
bool_inner = sqrt((x-c(1)).^2/c(1)^2 + (y-c(2)).^2/c(2)^2) <= 1;
bool_inner = permute(bool_inner,[3,1,2]);
samp_model = permute(samp_model,[3,1,2]);
[bool_adipose,bool_glandular] = constructXfgRegionS(bool_inner,targetGlaFrac);
samp_model(bool_adipose) = 2;
samp_model(bool_glandular) = 3;
bin = ceil(min(ceil(dim(1)/2),ceil(dim(2)/2))/5);
raf = zeros(bin,0);
for i = 1:10
    raf = cat(2,raf,RAF(squeeze(samp_model(i,:,:)),bin));
end
raf = mean(raf,2);
raf(raf==0)=1;
% interval = 1/length(raf);
% raf_x = interval/2:interval:1-interval/2;
% raf_x = raf_x';
% raf = raf.*raf_x;
% dice = polyfit(raf_x,raf,4);
% raf = dice(1)*raf_x.^4+dice(2)*raf_x.^3+dice(3)*raf_x.^2+dice(4)*raf_x+dice(5);
raf2 = raf/sum(raf);
end

function [bool_adipose,bool_glandular] = constructXfgRegionS(bool_inner,VBD)
bool_adipose = bool_inner;
bool_glandular = zeros(size(bool_inner),'logical');
nTotal = find(bool_inner);
n = size(nTotal,1);
nG = ceil(n*VBD/100);
RndInd = randi(length(nTotal),[nG,1]);
bool_glandular(nTotal(RndInd)) = 1;
bool_adipose = bool_adipose&~bool_glandular;
end

function [raf,raf2] = gauss_RA_dis(dim,targetGlaFrac)
samp_model = ones([dim(1),dim(2),10],'uint8');
[y,x,~] = meshgrid(1:dim(2), 1:dim(1), 1:10);
c = [ceil(dim(1)/2),ceil(dim(2)/2)];
bool_inner = sqrt((x-c(1)).^2/c(1)^2 + (y-c(2)).^2/c(2)^2) <= 1;
bool_inner = permute(bool_inner,[3,1,2]);
samp_model = permute(samp_model,[3,1,2]);
[bool_adipose,bool_glandular] = constructGaussfgRegionS(bool_inner,targetGlaFrac);
samp_model(bool_adipose) = 2;
samp_model(bool_glandular) = 3;
bin = ceil(min(ceil(dim(1)/2),ceil(dim(2)/2))/5);
raf = zeros(bin,0);
for i = 1:10
    raf = cat(2,raf,RAF(squeeze(samp_model(i,:,:)),bin));
end
raf = mean(raf,2);
raf(raf==0)=1;
% interval = 1/length(raf);
% raf_x = interval/2:interval:1-interval/2;
% raf_x = raf_x';
% raf = raf.*raf_x;
% dice = polyfit(raf_x,raf,4);
% raf = dice(1)*raf_x.^4+dice(2)*raf_x.^3+dice(3)*raf_x.^2+dice(4)*raf_x+dice(5);
raf2 = raf/sum(raf);
end

function [bool_adipose,bool_glandular] = constructGaussfgRegionS(bool_inner,VBD)
% 用于半圆球的模体抽样腺体 hemi shphere
bool_adipose = bool_inner;
nTotal = find(bool_inner);
n = size(nTotal,1);
nG = ceil(n*VBD/100);
Nx = size(bool_inner,1);

for i = 1:Nx
    bool_plane = squeeze(bool_inner(i,:,:));
    bool_plane_g = zeros(size(bool_plane),'logical');
    if size(bool_plane,1) == 0
        continue
    else
        [nx,ny] = size(bool_plane);
        A = length(find(bool_plane));
        frac = A/n;
        ng = floor(nG*frac);
        reff =  ceil(sqrt(A/pi));
        c = [ceil(nx/2),ceil(ny/2)];
        r = sampDis(xgauss(1000),ceil(frac*10*ng))*reff;
        theta = 2*pi*rand(ceil(frac*10*ng),1);
        gx = ceil(r.*cos(theta))+c(1);
        gy = ceil(r.*sin(theta))+c(2);
        gxy = cat(2,gx,gy);
        gxy(gx(:)<1|gx(:)>nx,:) = [];
        gy(gx(:)<1|gx(:)>nx) = [];%否则下一句有问题
        gxy(gy(:)<1|gy(:)>ny,:) = [];
        gxy = unique(gxy,'rows','stable');
        for j = 1:min(size(gxy,1),ng)
            bool_plane_g(gxy(j,1),gxy(j,2)) = 1;
        end
        bool_inner(i,:,:) = bool_plane_g;
    end
end
bool_adipose = bool_adipose&~bool_inner;
bool_glandular = bool_inner;
end

function raf = RAF(breastplane,bin)
raf =zeros(bin,1);

[Nxp,Nyp] = size(breastplane);
bool_breast = breastplane ~= 1;
[Y,X] = meshgrid(1:Nyp,1:Nxp);
x1 = X(bool_breast);
y1 = Y(bool_breast);
x_min = min(x1(:));
x_max = max(x1(:));
y_min = min(y1(:));
y_max = max(y1(:));
brplane = breastplane(x_min:x_max,y_min:y_max);

[Nxp,Nyp] = size(brplane);
[Y,X] = meshgrid(1:Nyp,1:Nxp);
a = floor(Nxp/2);
b = floor(Nyp/2);
c = [ceil(Nxp/2),ceil(Nyp/2)];

dist = (X-c(1)).^2/a^2 + (Y-c(2)).^2/b^2;
for i = 1:bin
    if i == 1
        region = dist <= (i/bin)^2;
    elseif i > 1
        region = dist <= (i/bin)^2 & dist > ((i-1)/bin)^2;
    end
    v_glandular = length(find(brplane == 3 & region));
    v_adipose = length(find(brplane == 2 & region));
    raf(i) = v_adipose/(v_glandular+v_adipose);
end
end