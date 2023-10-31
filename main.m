
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
bas = base(25);  % volume glandular fraction
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

% cup parameter;
c_cup;

shapeBreast = shape(rt,rb,rl,rr,rh,eps1,eps2,...
              ptosisB0,ptosisB1,turnC0,turnC1,...
              topShapeS0,topShapeS1,topShapeT0,topShapeT1,...
              flattenSideG0,flattenSideG1,turnTopH0,turnTopH1);
shapeBreast.shapeGridNum =100;

adipShRad = 4; 
disp([num2str(toc,formatSpec),'s  ->','Generate breast surface points and triangles... ']);
[surfVert,surfFaces,muscVert,muscFaces] = shapePly(shapeBreast,muscThick,leftBreast);

% voxelize initialize
disp([num2str(toc,formatSpec),'s  ->','Voxelize initialize... ']);
minxyz = min(surfVert); maxxyz = max(surfVert);
v = voxelize(5,maxxyz(1)+nippleLen+0.5,minxyz(1)-muscThick-0.5,...
               maxxyz(2)+skinThick+0.5,minxyz(2)-skinThick-0.5,...
               maxxyz(3)+skinThick+0.5,minxyz(3)-skinThick-0.5);
[Nx,Ny,Nz] = v.dim();

% ======triangle to voxel===========
% breast surface voxelize
disp([num2str(toc,formatSpec),'s  ->','breast surface voxelize... ']);
surfFV.vertices = surfVert;
surfFV.faces = surfFaces;
bool_surf = v.plyVoxelize(surfFV);
% muscle voxelize
disp([num2str(toc,formatSpec),'s  ->','muscle voxelize... ']);
muscFV.vertices = muscVert;
muscFV.faces = muscFaces;
bool_musc = v.plyVoxelize(muscFV);

% nipple voxelize
disp([num2str(toc,formatSpec),'s  ->','nipple voxelize... ']);
nippleP = surfVert(end,:);
bool_nipple =  (v.nippleVoxelize(nippleP,nippleRad,nippleLen))& ~bool_surf;
% skin voxelize
disp([num2str(toc,formatSpec),'s  ->','skin voxelize... ']);
bool_skin = bas.creSkin(v,bool_surf,bool_musc,bool_nipple,nippleP);

% subadipose voxelize
disp([num2str(toc,formatSpec),'s  ->','subadipose voxelize... ']);
[bool_fAdip,bool_bAdip,bool_fibGla] = bas.creSubAdip(v,bool_surf,nippleP,adipShRad);

% assign values to regions
disp([num2str(toc,formatSpec),'s  ->','assign values to regions... ']);
breast = ones(Nx,Ny,Nz,'uint8');   
breast(bool_skin) = tis.skin;     %9
breast(bool_musc) = tis.muscle;   %12
breast(bool_bAdip) = tis.bAdip;   %4
breast(bool_fAdip) = tis.fAdip;   %2
breast(bool_nipple) = tis.nipple; %9
breast(bool_fibGla) = tis.fgFiber;%6

% cooper voxelize
disp([num2str(toc,formatSpec),'s  ->','cooper voxelize... ']);
fDirect = [-10,0,0]; bDirect = [50,0,0];
bool_fCooper = v.cooperVoxelize(bool_fAdip,fDirect);
bool_bCooper = v.cooperVoxelize(bool_bAdip,bDirect);
bool_Cooper  = bool_fCooper|bool_bCooper;
% bool_Cooper = v.CooperVoxelize2(bool_surf,nippleP,cooperThick);
breast(bool_Cooper) = tis.cooper;

% duct tree and TDLU voxelize
disp([num2str(toc,formatSpec),'s  ->','duct tree and TDLU voxelize... ']);
[dTree,breast] = ductBranch.credTree(v,breast,nippleRad,nippleP);

% ampul voxelize
disp([num2str(toc,formatSpec),'s  ->','ampulla voxelize... ']);
breast = ductBranch.creAmpul(v,breast,nippleRad,nippleP);

% save breast1.mat
%%
% adipose ellip voxelize
disp([num2str(toc,formatSpec),'s  ->','adipose ellip voxelize... ']);
targetGlaFrac = bas.targetGlaFrac; % target glandularity
[breast,actualGlaFrac] = v.adipElVoxelize(targetGlaFrac,breast,nippleP);
%=============save parameter=================
time = regexprep(mat2str(clock),'[. []]','');
filename = [bas.outputDir,num2str(targetGlaFrac),'_',time,'.mat'];
save(filename,'breast','dTree','actualGlaFrac');
disp(['glandularity(VBD) ->',num2str(targetGlaFrac),'running time: ',num2str(toc,formatSpec),'s']);
disp(' Congratulations!!! breastPhantom Generate Successfully !!!');


