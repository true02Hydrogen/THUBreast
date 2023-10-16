function obj = branchPoint(obj,fomerPoint)
% branchPoint: based on the former point and the startPoint\theta\phi\h\ 
% of duct branch, determine the end point of duct branch.
% Input:
%   obj: instantiation of Class:ductBranch,undefine endP
%   fomerPoint: the start point of former duct branch.
% Output：
%   obj: define endP of obj.
% written by Wangjiahao

P1 = fomerPoint;
P2 = obj.startP;
X1 = P1(1); Y1 = P1(2); Z1 = P1(3); 
X2 = P2(1); Y2 = P2(2); Z2 = P2(3); 
theta = obj.theta;
phi = obj.phi;
h = obj.h;

[beta,psi,~] = cart2sph(X2-X1,Y2-Y1,Z2-Z1);
psi  = pi/2 -psi;
beta = pi/2 -beta;

endPlocal = [h*sin(theta)*cos(phi),h*sin(theta)*sin(phi),h*cos(theta)];
endP = [-cos(psi)*sin(beta)   cos(beta)    sin(psi)*sin(beta);...
        -cos(psi)*cos(beta)  -sin(beta)    sin(psi)*cos(beta);...
         sin(psi)             0            cos(psi)          ]...
        *endPlocal'+P2';
obj.endP = endP';
