
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

vgf = 35;
% cup parameter;
a_20;
voxSize = 0.2; res = 1/voxSize;

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
shapeBreast.shapeGridNum =100;

adipShRad = 4; 
disp([num2str(toc,formatSpec),'s  ->','Generate breast surface points and triangles... ']);
[surfVert,surfFaces] = shapePly(shapeBreast,leftBreast);

% voxelize initialize
disp([num2str(toc,formatSpec),'s  ->','Voxelize initialize... ']);
minxyz = min(surfVert); maxxyz = max(surfVert);

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

disp(['Volume glandular fraction (VGF) ->',num2str(targetGlaFrac),'. Running time: ',num2str(toc,formatSpec),'s']);
disp(' Congratulations!!! breastPhantom Generate Successfully !!!');


