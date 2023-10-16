function Vfat = targetVfat_vbd(v,breast,targetVBD)
% targetVfat: obtain the target adipose volume of breast needed
% Input:
%   v: instantiation of Class:tissue
%   breast: breast matrix, Nx*Ny*Nz
%   targetGlaFrac: target vbd
% Output：
%   Vfat: target adipose volume
% written by Wangjiahao

t = tissue();

numVoxel = length(find(breast ~= t.air&breast ~= t.muscle&breast ~= t.skin));
voxelVolume = (1/v.Res)^3;
V = numVoxel*voxelVolume;
Vfatcooper = V*(100-targetVBD)/100;

nVoxelsubpost = length(find(breast == t.bAdip|breast == t.fAdip|breast == t.cooper));
Vsubpost = nVoxelsubpost*voxelVolume;

Vfat = Vfatcooper - Vsubpost;
end

