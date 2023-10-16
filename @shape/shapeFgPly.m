function [surfVert,surfFaces] = shapeFgPly(obj,leftBreast,nippleP,adipnThick)
% shapePly: obtain the breast surface shape and muscle shape
%           consisting of triangles and vertices
% Input:
%   obj: instantiation of Class:shape
%   leftBreast: left breast or right breast
% Output：
%   surfVert: the vertices of fiborglandular boundary shape; 
%             the final point is the position of nipple; 
%   surfFaces: the faces of fiborglandular boundary shape;
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
doTopShape = obj.doTopShape;
doFlattenSide = obj.doFlattenSide;
doTurnTop = obj.doTurnTop;
doPtosis = obj.doPtosis;
doTurn = obj.doTurn;

doArmpit = obj.doArmpit;
dirc = obj.dirc;
sigma = obj.sigma;

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
surfAngles = cat(1,roota,angle,nipplea);

surfDT = delaunayTriangulation(surfVert);
[surfFaces,~] = convexHull(surfDT);
P0 = surfVert;

% deformation
P0 = shape.addArmpit(doArmpit,P0,dirc,sigma);
P1 = shape.topshapeDeform(doTopShape,P0,surfAngles,s0,t0,s1,t1);
P2 = shape.flattensideDeform(doFlattenSide,P1,g0,g1,leftBreast);
P3 = shape.turntopDeform(doTurnTop,P2,h0,h1,leftBreast);
P4 = shape.ptosisDeform(doPtosis,P3,b0,b1);
surfVert = shape.turnDeform(doTurn,P4,c0,c1);

nipplep = surfVert(end,:);
displace = nippleP - nipplep - [adipnThick,0,0];
surfVert = surfVert + displace;
end
