function startP = startPSamp(nDuct,r0,nippleP,nippleR)
% startPSamp: sample the start point inner the circle
% Input:
%   nuDuct: the number of duct
%   r0: the radius of ampulla or vessel or duct
%   nippleP: the position of nipple, [X,Y,Z]
%   nippleR: the radius of nipple
% Output：
%   startP: the start point for generating duct tree or ampulla or vessel,
%           [X1,Y1,Z1;X2,Y2,Z2;...Xn,Yn,Zn] nDuct*3
% written by Wangjiahao

reserved = 5000;
r = (nippleR-1.5*r0)*sqrt(rand(reserved,1));
theta = 2*pi*rand(reserved,1);
startPtemp = NaN(reserved,2); % It is used to store points that are more than 2*r0 from each other and 1.5*r0 from the edge
startPtemp(1,:) = [r(1),theta(1)]; 
counter = 1; % Record how many valid Cooper center points there are
tag = 1;     % Determine distance identifier If there is a point with a distance less than 2*r0, set it to 0.
for i=2:reserved
    sph2=[r(i),theta(i)];
    for j=1:counter
        if distance(sph2,startPtemp(j,:))< 2*r0
        tag = 0; 
        break
        end
    end
    if  tag == 1
        counter = counter+1;
        startPtemp(counter,:) = sph2;
    else 
       tag = 1;
    end
end
nEffect = length(find(~isnan(startPtemp)))/2; %Number of valid points in the dTree
[Y,Z] = pol2cart(startPtemp(:,2),startPtemp(:,1));
startPtemp = [Y+nippleP(2),Z+nippleP(3)];
if nDuct <= nEffect
    startP = startPtemp(1:nDuct,:);
else
    startP = startPtemp(1:nEffect,:);
    disp(['The number of effective point is ' ...
        'less than the number of start Point(duct or ampul) needed']);
end

end

function c = distance(sph1,sph2)
    a = sph1(1); b = sph2(1); theta = sph1(2)-sph2(2);
    c = a^2+b^2-2*a*b*cos(theta);
end
