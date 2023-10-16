function glandularity = glandularity(obj,breast)
% glandularity: obtain the glandularity of breast
% Input:
%   obj: v: instantiation of Class:tissue
%   breast: breast matrix, Nx*Ny*Nz
% Output：
%   glandularity
% written by Wangjiahao

% the density of adipose and glandular, ICRU 46,g/cm3
rhoFat=0.95; rhoFG=1.02; 
massFG  = length(find(breast == obj.fgFiber| ...
    breast == obj.gland|breast == obj.ampul| ...
    breast == obj.dTree  |breast == obj.lob))*rhoFG;
massFat = length(find(breast == obj.fgAdip))*rhoFat;
glandularity = massFG/(massFG+massFat)*100;

