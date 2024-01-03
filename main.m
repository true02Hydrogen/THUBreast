
% Author: Wang Jiahao
% Mar 10/2022

%Initialize
clear; setup;

tic
% argument
disp('The breast phantom generation process is started now.');
disp(datetime("now"));
disp('Parameter initialize... ');
formatSpec = '%.2f';
tis = tissue();

% cup parameter;
vgf = 35; 
voxSize = 0.2; %mm
c_cup; 
seed = ceil(rand*1e8);
%

bas = base(vgf);  % volume glandular fraction
nippleRad = bas.nippleRad;
nippleLen = bas.nippleLen;
areolaRad = bas.areolaRad;
muscThick = bas.muscThick;
skinThick = bas.skinThick;
leftBreast = bas.leftBreast;
adipnThick = bas.adipnThick; 
adipbThick = bas.adipbThick; 
adipSamThick = bas.adipSamThick; 
cooperThick = bas.cooperThick;

shapeBreast = shape(rt,rb,rl,rr,rh,eps1,eps2,...
              ptosisB0,ptosisB1,turnC0,turnC1,...
              topShapeS0,topShapeS1,topShapeT0,topShapeT1,...
              flattenSideG0,flattenSideG1,turnTopH0,turnTopH1);
shapeBreast.shapeGridNum =20;

adipShRad = 4; 
disp([num2str(toc,formatSpec),'s  ->','Generate breast surface points and triangles... ']);
[surfVert,surfFaces] = shapePly(shapeBreast,leftBreast);

% voxelize initialize
disp([num2str(toc,formatSpec),'s  ->','Voxelize initialize... ']);
minxyz = min(surfVert); maxxyz = max(surfVert);
res = 1/voxSize;
disp(['The voxel size is ',num2str(voxSize*1000,'%d'),'um;']);
v = voxelize(res,maxxyz(1)+nippleLen+0.5,minxyz(1)-0.5,...
               maxxyz(2)+skinThick+0.5,minxyz(2)-skinThick-0.5,...
               maxxyz(3)+skinThick+0.5,minxyz(3)-skinThick-0.5);
[Nx,Ny,Nz] = v.dim();

% ======triangle to voxel===========
% breast surface voxelize
disp([num2str(toc,formatSpec),'s  ->','breast surface voxelize... ']);
surfFV.vertices = surfVert;
surfFV.faces = surfFaces;
bool_surf = v.plyVoxelize(surfFV);

breast = ones(Nx,Ny,Nz,'uint8');  
% nipple voxelize
disp([num2str(toc,formatSpec),'s  ->','nipple voxelize... ']);
nippleP = surfVert(end,:);
bool_nipple =  (v.nippleVoxelize(nippleP,nippleRad,nippleLen))& ~bool_surf;
breast(bool_nipple) = tis.nipple; %9

% skin voxelize
disp([num2str(toc,formatSpec),'s  ->','skin voxelize... ']);
bool_skin = bas.creSkin(v,bool_surf,bool_nipple,nippleP);
breast(bool_skin) = tis.skin;     %9
clear bool_skin bool_nipple

% subadipose voxelize
disp([num2str(toc,formatSpec),'s  ->','subadipose voxelize... ']);
[bool_fAdip,bool_bAdip,bool_fibGla] = bas.creSubAdip(v,bool_surf,nippleP,adipShRad);
breast(bool_bAdip) = tis.bAdip;   %4
breast(bool_fAdip) = tis.fAdip;   %2
breast(bool_fibGla) = tis.fgFiber;%6
clear bool_fibGla bool_surf

% cooper voxelize
disp([num2str(toc,formatSpec),'s  ->','cooper voxelize... ']);
fDirect = [-10,0,0]; bDirect = [50,0,0];
bool_fCooper = v.cooperVoxelize(bool_fAdip,fDirect);
bool_bCooper = v.cooperVoxelize(bool_bAdip,bDirect);
bool_Cooper  = bool_fCooper|bool_bCooper;
breast(bool_Cooper) = tis.cooper;
clear bool_Cooper bool_fCooper bool_bCooper bool_bAdip bool_fAdip

% duct tree and TDLU voxelize
disp([num2str(toc,formatSpec),'s  ->','duct tree and TDLU voxelize... ']);
[dTree,breast] = ductBranch.credTree(v,breast,nippleRad,nippleP);

% ampul voxelize
disp([num2str(toc,formatSpec),'s  ->','ampulla voxelize... ']);
breast = ductBranch.creAmpul(v,breast,nippleRad,nippleP);

% adipose ellip voxelize
disp([num2str(toc,formatSpec),'s  ->','adipose ellip voxelize... ']);
targetGlaFrac = bas.targetGlaFrac; % target glandularity
[breast,actualGlaFrac] = v.adipElVoxelize(targetGlaFrac,breast,nippleP);

% muscle and virtual adipose layer voxlize
breast = minbreast(breast);
slice = breast(1,:,:) == tis.bAdip;
bool_musc = v.muscleVoxelize(slice,muscThick);
virtualAdipThick = 6;
bool_virtualAdip = v.virtualAdipVoxelize(slice,virtualAdipThick);
muscle = zeros(size(bool_musc),'uint8');  muscle(bool_musc) = tis.muscle;
virtualAdip = zeros(size(bool_virtualAdip),'uint8'); virtualAdip(bool_virtualAdip) = tis.bAdip;
clear bool_musc bool_virtualAdip;
breast = cat(1,muscle,virtualAdip,breast);
disp([num2str(toc,formatSpec),'s  ->','muscle and virtual adipose layer voxelize... ']);

%=============save parameter====================
saveraw(breast,seed,targetGlaFrac);

disp(['Volume glandular fraction (VGF) ->',num2str(targetGlaFrac),'running time: ',num2str(toc,formatSpec),'s']);
disp(' Congratulations!!! breastPhantom Generate Successfully !!!');


