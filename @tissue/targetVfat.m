function Vfat = targetVfat(v,breast,targetGlaFrac)
% targetVfat: obtain the target adipose volume of breast needed
% Input:
%   v: instantiation of Class:tissue
%   breast: breast matrix, Nx*Ny*Nz
%   targetGlaFrac: target glandularity
% Output：
%   Vfat: target adipose volume
% written by Wangjiahao

t = tissue();
% the density of adipose and glandular, ICRU 46,g/cm3
rhoFat=0.95;rhoFG=1.02; 
numVoxel = length(find(breast == t.fgFiber|breast == t.gland|breast == t.ampul|...
    breast == t.dTree|breast == t.lob|breast == t.fgAdip));
voxelVolume = (1/v.Res)^3;
V = numVoxel*voxelVolume;
if targetGlaFrac == 100
    Vfat = 0;
else
    Vfat = V/(1+rhoFat/rhoFG*(targetGlaFrac/(100-targetGlaFrac)));
end
end

