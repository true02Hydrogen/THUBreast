classdef ductBranch < handle

    properties
        startP = 0; % start point of a duct branch
        endP = 0;   % end point of a duct branch
        theta = 0;  % The polar Angle of the branch with respect to the previous branch
        phi = 0;    % The direction Angle of the branch with respect to the previous branch
        r = 0;      % radius of a duct branch
        tag = 0;    % If there is a branch, the non-terminal branch is marked with 1, and the terminal branch is marked with 0.
        sort;       % Record which branch each branch belongs to, 1~nDuct
        h;
    end

    methods
        function obj = ductBranch(startP,endP,theta,phi,h,r,tag,sort)

            if nargin == 0 
                obj.startP = nan;
                obj.endP = nan;
                obj.theta = nan;
                obj.phi = nan;
                obj.h = nan;
                obj.r = nan;
                obj.tag = nan;
                obj.sort = nan;
                disp("default duct 'all nan' ");
            else
                obj.startP = startP;
                obj.endP = endP;
                obj.theta = theta;
                obj.phi = phi;
                obj.h = h;
                obj.r = r; 
                obj.tag = tag;
                obj.sort = sort;
            end
        end

        Pnew = branchPoint(P1,P2,theta,phi,Hnew);
        
    end

   methods (Static)
       [dTree,breast] = credTree(v,breast,nippleR,nippleP);
       breast = creAmpul(v,breast,nippleR,nippleP);
       startP = startPSamp(nDuct,r0,nippleP,nippleR);
   end
end

