function [bool_fAdip,bool_bAdip,bool_fibGla] = creSubAdip(obj,v,bool_surf,nippleP,adipShRad)
% creSkin: % create skin logical area
% Input:
%   obj: instantiation of Class:base
%   v:   instantiation of Class:voxelize
%   bool_surf: breast surface(exclude skin) logical area, Nx*Ny*Nz matrix
%   nippleP: the position of breast nipple, [X,Y,Z]
%   adipShRad: the radius of adipose shpere for generating fiberglandular
%   boundary
% Output:
%   bool_fAdip: ventral(front) adipose logical area, Nx*Ny*Nz matrix
%   bool_bAdip: postero-lateral(back) adipose logical area, Nx*Ny*Nz matrix
%   bool_fibGla: fiberglandular logical area, Nx*Ny*Nz matrix
% written by Wangjiahao

adipnThick = obj.adipnThick;
adipbThick = obj.adipbThick;
adipSamThick = obj.adipSamThick;
res = v.Res;

%% Judge the anterior and posterior surfaces of the breast separately
% obtain a layer of voxel from the breast surface(exclude skin)
bool_surf2 = bwperim(bool_surf,6);
pvnSurf2 = zeros(1,size(bool_surf2,1));%plane voxel number(xz plane)
for i = 1:size(bool_surf2,1)
    pvnSurf2(i) = size(find(bool_surf2(i,:,:)),1);
end
pvnSurf2Mp = find(pvnSurf2 == max(pvnSurf2,[],2));%plane voxel number / max position
bool_surf2b = zeros(size(bool_surf2),'logical');
bool_surf2f = zeros(size(bool_surf2),'logical');
bool_surf2b(pvnSurf2Mp,:,:) = bool_surf2(pvnSurf2Mp,:,:);
bool_surf2f(pvnSurf2Mp+1:end,:,:) = bool_surf2(pvnSurf2Mp+1:end,:,:);

%% obtain ventral(front) adipose logical area and postero-lateral(back) adipose logical area
distSurff = bwdist(bool_surf2f); clear bool_surf2f;

bNipple = zeros(size(bool_surf2),'logical'); clear bool_surf2;
nPX = nippleP(1); nPY = nippleP(2); nPZ = nippleP(3);
[nPx,nPy,nPz] = XYZ2xyz(v,nPX,nPY,nPZ);
bNipple(nPx,nPy,nPz) = 1;
distNipple = bwdist(bNipple); clear bNipple;
[~,~,Nz] = v.dim();
adipThick = adipnThick + 0.005*distNipple/res + 0.002*(distNipple/res).^2; clear distNipple;
for z = 1:Nz
    adipThick(:,:,z) = adipThick(:,:,z)*(0.5+(z/Nz)*0.8);
end

% ventral(front) adipose logical area
bool_fAdip = (distSurff < ceil(adipThick*res) & bool_surf); clear distSurff;

% postero-lateral(back) adipose logical area, exclude ventral(front) adipose logical area
distSurfb = bwdist(bool_surf2b); clear bool_surf2b;

bool_bAdip = (distSurfb < ceil(adipbThick*res) & bool_surf & ~bool_fAdip); clear distSurfb;
bool_fibGla = bool_surf&~(bool_fAdip|bool_bAdip); clear bool_surf;


distfibGla = bwdist(bool_fibGla);
% the distance between sample area and fiberglandular is range 1mm to 3mm;
bool_fAdipSamp = (distfibGla < ceil((adipSamThick+1)*res)...
    & distfibGla > ceil(1*res) & bool_fAdip); clear distfibGla;

% sample 2000 points from ventral(front) adipose logical area
tempfAdip = v.adipShVoxelize(bool_fAdipSamp,2000,adipShRad); clear bool_fAdipSamp;
bool_fAdip = bool_fAdip|(bool_fibGla&tempfAdip); clear tempfAdip;
% sample 2000 points from postero-lateral(back) adipose logical area
tempbAdip = v.adipShVoxelize(bool_bAdip,2000,adipShRad);
bool_bAdip = bool_bAdip|(bool_fibGla&tempbAdip); clear tempbAdip;

% obtain adipose logical area and fiborglandular logical area
bool_Adip = bool_bAdip|bool_fAdip;
bool_fibGla= ~bool_Adip&bool_fibGla;
