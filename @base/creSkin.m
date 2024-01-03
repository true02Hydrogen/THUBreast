function bool_skin = creSkin(obj,v,bool_surf,bool_nipple,nippleP)
% creSkin: % create skin logical area
% Input:
%   obj: instantiation of Class:base
%   v:   instantiation of Class:voxelize
%   bool_surf: breast surface(exclude skin) logical area, Nx*Ny*Nz matrix
%   bool_nipple: breast nipple logical area, Nx*Ny*Nz matrix
%   nippleP: the position of breast nipple, [X,Y,Z]
% Output：
%   bool_mat: breast skin logical area, Nx*Ny*Nz matrix
% written by Wangjiahao

skinThick = obj.skinThick;
areolaRad = obj.areolaRad;

%% obtain breast skin logical area of general skin thickness
% obtain a layer of voxel from the breast surface(exclude skin)
bool_surf2 = bwperim(bool_surf,6); 

pvnSurf2 = zeros(1,size(bool_surf2,1));%plane voxel number(xz plane)
for i = 1:size(bool_surf2,1)
    pvnSurf2(i) = size(find(bool_surf2(i,:,:)),1);
end
pvnSurf2Mp = find(pvnSurf2 == max(pvnSurf2,[],2));%plane voxel number / max position


distWholeSurf = bwdist(bool_surf2);
bool_skin = (distWholeSurf<ceil(skinThick*v.Res)&distWholeSurf>0)...
    &~bool_surf; clear distWholeSurf;

%% obtain breast skin logical area of areola
nPX = nippleP(1); nPY = nippleP(2); nPZ = nippleP(3);
[nPx,nPy,nPz] = XYZ2xyz(v,nPX,nPY,nPZ);
% obtain local areola area
[xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = Box(v,nippleP,areolaRad);
arlaSurf = bool_surf(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp);
bNipple = zeros(size(arlaSurf),'logical');
bNipple(nPx-xBoxLow+1,nPy-yBoxLow+1,nPz-zBoxLow+1) = 1;
distArSurf = bwdist(arlaSurf);
distNipple = bwdist(bNipple);
areolaH = skinThick + skinThick./(1+exp(12./(areolaRad.*(distNipple-areolaRad))));

arlaSurf = (distArSurf < ceil(areolaH*v.Res) ...
    & distArSurf > 0 & distNipple < ceil(areolaRad*v.Res));
bool_skin(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
    bool_skin(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)|arlaSurf;
bool_skin = bool_skin& ~bool_nipple; % exclude nipple logical area

bool_skin(1:pvnSurf2Mp-1,:,:) = 0;
end

