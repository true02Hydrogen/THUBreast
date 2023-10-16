function [dTree,breast] = credTree(v,breast,nippleR,nippleP)
% credTree: create duct tree logical area
% Input:
%   v: instantiation of Class:voxelize
%   breast: breast matrix, Nx*Ny*Nz
%   nippleR: the radius of nipple
%   nippleP: the position of nipple, [X,Y,Z]
% Output：
%   dTree: all information about duct branch
%   breast: breast matrix, added ampullae, Nx*Ny*Nz
% written by Wangjiahao

t = tissue();
bool_fibGla = (breast == t.fgFiber);
reserved = 3000; % reserved space
nDuct = 17; % the number of duct
r0 = 1;     % the radius of initial duct branch: 1mm
hmin = 3;   % When the branch length is less than hmin, stop the branch process

dTreeStartPYZ = ductBranch.startPSamp(nDuct,r0,nippleP,nippleR);
dTreeStartPX = repmat(nippleP(1)-4,size(dTreeStartPYZ,1),1);
dTreeStartP = cat(2,dTreeStartPX,dTreeStartPYZ);
dTree(reserved,1) = ductBranch();
for i = 1:nDuct
    h = 6 + rand;
    dTree(i) = ductBranch(dTreeStartP(i,:),nan,0,0,h,r0,1,i);
    dTree(i).branchPoint(nippleP);
end
bool_dTree = zeros(size(breast),'logical');
% The 17 base ducts are added to the Breast.
for i = 1:nDuct
    [baseBranch,box] = v.cylinderVoxelize(dTree(i).startP,dTree(i).endP,dTree(i).r);
    xBoxLow = box(1); xBoxUp = box(2);
    yBoxLow = box(3); yBoxUp = box(4);
    zBoxLow = box(5); zBoxUp = box(6);
    bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
        bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) | baseBranch;
    % Initializes the pole Angle set for the next branch pole Angle sample
    dTree(i).theta = pi/6;
end

counter = nDuct; % the total number of duct branch
ind = 1;  % ind是指向存储分支信息矩阵的指针,从该指针指向的分支处分叉
while 1
    if (dTree(ind).tag == 0)&&(ind==counter) 
        break
    elseif (dTree(ind).tag == 0)&&(ind~=counter)
        ind = ind + 1;
    else
       dTree(ind).tag = 0; %用来记录当前ind所指向节点是否有分支。
       P1 = dTree(ind).startP;
       P2 = dTree(ind).endP;
       r  = dTree(ind).r;
       [formerBranch,box] = v.cylinderVoxelize(P1,P2,r);
       xBoxLow = box(1); xBoxUp = box(2);
       yBoxLow = box(3); yBoxUp = box(4);
       zBoxLow = box(5); zBoxUp = box(6);
       tempdTree = bool_dTree;
       tempdTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
            tempdTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) & ~formerBranch;
       %temp中上一个分支的体素值设为0，其他分支为1
       loop = 20; %设置分支失败后尝试次数
       while loop         
           phi  = rand*2*pi; %方位角设为0~2pi;
           theta= max(dTree(ind).theta*(0.5+rand),15/180*pi);%在上一个分支极角基础上计算当前分支的极角,且不能小于15°
           Hnew = dTree(ind).h * (0.6+0.4*rand);
           Rnew = Hnew/dTree(dTree(ind).sort).h*r0;
           d = ductBranch(P2,nan,theta,phi,Hnew,Rnew,nan,nan);
           d.branchPoint(P1);
           %!此处加入分支舍弃判断程序
           [newBranch,box] = v.cylinderVoxelize(d.startP,d.endP,d.r);
           xBoxLow = box(1); xBoxUp = box(2);
           yBoxLow = box(3); yBoxUp = box(4);
           zBoxLow = box(5); zBoxUp = box(6);
           if (~isscalar(newBranch))&& ...
              isempty(find(tempdTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)&newBranch,1))...%新生成的分支与上一个分支外的分支无交叉
           && isempty(find(~bool_fibGla(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)&newBranch,1)) %新生成的分支在纤维腺体区内
               counter = counter + 1;
               d.tag = (Hnew>=hmin);
               d.sort = dTree(ind).sort;
               dTree(counter) = d;
               bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
                   bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) | newBranch;
               dTree(ind).tag = 1;
               loop = 0;
           else
               loop = loop-1;
           end
       end
           
       %------生成第二个分支(与第一个对称±30°)--------
       loop=20;
       while loop
           phi = phi+pi-pi/6+rand*pi/3;
           theta= max(dTree(ind).theta*(0.5+rand),15/180*pi);
           Hnew = dTree(ind).h * (0.6+0.4*rand);
           Rnew = Hnew/dTree(dTree(ind).sort).h*r0;
           d = ductBranch(P2,nan,theta,phi,Hnew,Rnew,nan,nan);
           d.branchPoint(P1);
           %!此处加入分支舍弃判断程序
           [newBranch,box] = v.cylinderVoxelize(d.startP,d.endP,d.r);
           xBoxLow = box(1); xBoxUp = box(2);
           yBoxLow = box(3); yBoxUp = box(4);
           zBoxLow = box(5); zBoxUp = box(6);
           if (~isscalar(newBranch))&& ...
              isempty(find(tempdTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)&newBranch,1))...%新生成的分支与上一个分支外的分支无交叉
           && isempty(find(~bool_fibGla(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)&newBranch,1)) %新生成的分支在纤维腺体区内
               counter = counter+1;
               d.tag = (Hnew>=hmin);
               d.sort = dTree(ind).sort;
               dTree(counter) = d;
               bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
                   bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) | newBranch;
               dTree(ind).tag = 1;
               loop=0;
           else
               loop=loop-1;
           end
       end
        
       %----------是否生成第三个分支---------
       if randi([2,3])==3     %若为3，则生成最后一个分支，1/2概率
           loop = 20;
           while loop
               phi = phi-pi/6-phi/2*rand; %第三个分支与第二个分支的方位角相差pi/6~2pi/3;
               theta= max(dTree(ind).theta*(0.5+rand),15/180*pi);
               Hnew = dTree(ind).h * (0.6+0.4*rand);
               Rnew = Hnew/dTree(dTree(ind).sort).h*r0;
               d = ductBranch(P2,nan,theta,phi,Hnew,Rnew,nan,nan);
               d.branchPoint(P1);
               %!此处加入分支舍弃判断程序
               [newBranch,box] = v.cylinderVoxelize(d.startP,d.endP,d.r);
               xBoxLow = box(1); xBoxUp = box(2);
               yBoxLow = box(3); yBoxUp = box(4);
               zBoxLow = box(5); zBoxUp = box(6);
               if (~isscalar(newBranch))&& ...
                  isempty(find(tempdTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)&newBranch,1))...%新生成的分支与上一个分支外的分支无交叉
               && isempty(find(~bool_fibGla(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp)&newBranch,1)) %新生成的分支在纤维腺体区内
                   counter = counter+1;
                   d.tag = (Hnew>=hmin);
                   d.sort = dTree(ind).sort;
                   dTree(counter) = d;
                   bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
                       bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) | newBranch;
                   dTree(ind).tag = 1;
                   loop = 0;
               else
                   loop=loop-1;
               end
           end
       end
       %------------指向下一个枝杈，从其末端进行分支---------    
       ind = ind + 1;
    end
end
dTree = findobj(dTree,'tag',0,'-or','tag',1); % exclude NaN;

%% start terminal notch of duct branch and TDLU voxelize
% start terminal notch of duct branch voxelize
for i=1:size(dTree,1)
    [ductS,box] = v.shpereVoxelize(dTree(i).startP,dTree(i).r);
    xBoxLow = box(1); xBoxUp = box(2);
    yBoxLow = box(3); yBoxUp = box(4);
    zBoxLow = box(5); zBoxUp = box(6);
    bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
        bool_dTree(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) | ductS;
end
breast(bool_dTree) = t.dTree; 

% TDLU voxelize
bool_lob = zeros(size(breast),'logical');
dTreeLob = findobj(dTree,'tag',0);% find the terminal of duct
rLob = 0.5; % the radius of TDLU, mm
for i=1:size(dTreeLob,1)
    [lob,box] = v.shpereVoxelize(dTreeLob(i).endP,rLob);
    xBoxLow = box(1); xBoxUp = box(2);
    yBoxLow = box(3); yBoxUp = box(4);
    zBoxLow = box(5); zBoxUp = box(6);
    bool_lob(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) = ...
        bool_lob(xBoxLow:xBoxUp,yBoxLow:yBoxUp,zBoxLow:zBoxUp) | lob;
end
breast(bool_lob) = t.lob; 

