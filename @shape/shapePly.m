function [surfVert,surfFace] = shapePly(obj,leftBreast)
% shapePly: obtain the breast surface shape and muscle shape
%           consisting of triangles and vertices
% Input:
%   obj: instantiation of Class:shape
%   leftBreast: left breast or right breast
% Output：
%   surfVert: the vertices of breast surface shape; 
%             the final point is the position of nipple; 
%   surfFace: the faces of breast surface shape
% written by Wangjiahao

%% shape parameter
gridnum = obj.shapeGridNum;
rt = obj.rt;
rb = obj.rb;
rl = obj.rl;
rr = obj.rr;
rh = obj.rh;
eps1 = obj.eps1;
eps2 = obj.eps2;
b0 = obj.ptosisB0;
b1 = obj.ptosisB1;
c0 = obj.turnC0;
c1 = obj.turnC1;
s0 = obj.topShapeS0;
s1 = obj.topShapeS1;
t0 = obj.topShapeT0;
t1 = obj.topShapeT1;
g0 = obj.flattenSideG0;
g1 = obj.flattenSideG1;
h0 = obj.turnTopH0;
h1 = obj.turnTopH1;
k0 = obj.corElongK0;
k1 = obj.corElongK1;
k2 = obj.corElongK2;
doTopShape = obj.doTopShape;
doFlattenSide = obj.doFlattenSide;
doTurnTop = obj.doTurnTop;
doPtosis = obj.doPtosis;
doTurn = obj.doTurn;
doCoronalElongate = true;

%% breast surface shape triangles and vertices
% bottom right
thetabr = -pi:pi/gridnum:(-pi/2-pi/gridnum);
phibr   = 0:pi/gridnum:(pi/2-pi/gridnum);
[Thetabr,Phibr] = meshgrid(thetabr,phibr);
xbr = rh*sin(Phibr).^eps1;
ybr = rr*cos(Phibr).^eps1.*(sin(Thetabr).^eps2);
zbr = rb*cos(Phibr).^eps1.*(cos(Thetabr).^eps2);

% top right breast
thetatr = -pi/2:pi/gridnum:(0-pi/gridnum);
phitr   = 0:pi/gridnum:(pi/2-pi/gridnum);
[Thetatr,Phitr] = meshgrid(thetatr,phitr);
xtr = rh*sin(Phitr).^eps1;
ytr = rr*cos(Phitr).^eps1.*sin(Thetatr).^eps2;
ztr = rt*cos(Phitr).^eps1.*cos(Thetatr).^eps2;

% top left breast
thetatl = 0:pi/gridnum:(pi/2-pi/gridnum);
phitl = 0:pi/gridnum:(pi/2-pi/gridnum);
[Thetatl,Phitl] = meshgrid(thetatl,phitl);
xtl = rh*sin(Phitl).^eps1;
ytl = rl*cos(Phitl).^eps1.*sin(Thetatl).^eps2;
ztl = rt*cos(Phitl).^eps1.*cos(Thetatl).^eps2;

% bottom left breast
thetabl = pi/2:pi/gridnum:(pi-pi/gridnum);
phibl = 0:pi/gridnum:(pi/2-pi/gridnum);
[Thetabl,Phibl] = meshgrid(thetabl,phibl);
xbl = rh*sin(Phibl).^eps1;
ybl = rl*cos(Phibl).^eps1.*sin(Thetabl).^eps2;
zbl = rb*cos(Phibl).^eps1.*cos(Thetabl).^eps2;

x = cat(2,xbr,xtr,xtl,xbl);
y = cat(2,ybr,ytr,ytl,ybl);
z = cat(2,zbr,ztr,ztl,zbl);
Theta = cat(2,Thetabr,Thetatr,Thetatl,Thetabl);
Phi = cat(2,Phibr,Phitr,Phitl,Phibl);
x = x'; y = y';z = z'; Theta = Theta';Phi = Phi';
P = cat(2,x(:),y(:),z(:));
angle = cat(2,Theta(:),Phi(:));
rootp = [0,0,0];
roota = [0,0];
nipplep = [rh,0,0];
nipplea = [0,pi/2];

surfVert = cat(1,rootp,P,nipplep);
surfAngle = cat(1,roota,angle,nipplea);

surfDT = delaunayTriangulation(surfVert);
[surfFace,~] = convexHull(surfDT);
P0 = surfVert;

% deformation
% P00 = shape.addArmpit(P0);
P1 = shape.topshapeDeform(doTopShape,P0,surfAngle,s0,t0,s1,t1);
P2 = shape.flattensideDeform(doFlattenSide,P1,g0,g1,leftBreast);
P3 = shape.turntopDeform(doTurnTop,P2,h0,h1,leftBreast);
P4 = shape.ptosisDeform(doPtosis,P3,b0,b1);
P5 = shape.turnDeform(doTurn,P4,c0,c1);
surfVert = shape.coronalElongateDeform(doCoronalElongate,P5,k0,k1,k2);

figure
subplot(1,2,1)
trisurf(surfFace,surfVert(:,1),surfVert(:,2),surfVert(:,3))
axis equal
l = light;
l.Color = [1 1 1];
l.Position = [200 -200 200];
lighting phong
material  dull
view([45 -45 45]);
axes('position',[0.1  .1  3  3])


subplot(2,2,2)
trisurf(surfFace,surfVert(:,1),surfVert(:,2),surfVert(:,3))
axis equal
l = light;
l.Color = [1 1 1];
l.Position = [200 -200 200];
lighting phong
material  dull
view([0 0]);
axes('position',[.1  .1  2  .6])

subplot(2,2,4)
trisurf(surfFace,surfVert(:,1),surfVert(:,2),surfVert(:,3))
axis equal
l = light;
l.Color = [1 1 1];
l.Position = [200 0 200];
lighting phong
material  dull
view([90 0]);
axes('position',[2.1  .1  .8  .6])
% print('p0','-dpng','-r600');

% figure('Color',[1,1,1])
% trisurf(surfFace,surfVert(:,1),surfVert(:,2),surfVert(:,3));
% trisurf(surfFace,surfVert(:,1),surfVert(:,2),surfVert(:,3),'EdgeColor','none');
% trisurf(surfFace,surfVert(:,1),surfVert(:,2),surfVert(:,3));
% axis equal
% axis off
% l = light;
% l.Color = [1 1 1];
% l.Position = [200 0 200];
% lighting phong
% material  dull

%% muscle triangles and vertices
% check = (Phi == 0);
% muscPlane1 = surfVert(check,:);
% muscPlane2 = cat(2,muscPlane1(:,1)-muscThick,...
%     muscPlane1(:,2),muscPlane1(:,3));
% muscVert = cat(1,muscPlane1,muscPlane2);
% muscDT = delaunayTriangulation(muscVert);
% [muscFaces,~] = convexHull(muscDT);
