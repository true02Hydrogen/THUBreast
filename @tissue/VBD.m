function [vbd,maxvbd] = VBD(obj,breast)

% vbd: obtain the vbd of breast
% Input:
%   obj: v: instantiation of Class:tissue
%   breast: breast matrix, Nx*Ny*Nz
% Output：
%   vbd
% written by Wangjiahao

volumeBreast  = length(find(breast ~= obj.air & breast ~= obj.skin ...
            & breast ~= obj.muscle));
volumeGlandular = length(find(breast == obj.fgFiber| ...
            breast == obj.gland|breast == obj.ampul| ...
            breast == obj.dTree  |breast == obj.lob));

volumeFiberR = length(find(breast == obj.fgFiber| ...
            breast == obj.gland|breast == obj.ampul| ...
            breast == obj.dTree  |breast == obj.lob |breast == obj.fgAdip));

vbd = volumeGlandular/volumeBreast*100;

maxvbd = volumeFiberR/volumeBreast*100;

