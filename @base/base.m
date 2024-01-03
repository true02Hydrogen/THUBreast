% Author: Wang Jiahao
% Mar 10/2022

classdef base < handle
    %base parameter
    properties
        targetGlaFrac = 50; % target glandular fraction 
        skinThick = 1.45; % skin thickness
        nippleLen = 6; % nipple length
        nippleRad = 6; % nipple radius
        areolaRad = 8; % areola radius
        muscThick = 10; % postero-lateral(back) muscle thickness
        adipbThick = 3; % postero-lateral(back) adipose thickness
        adipnThick = 3; % adipose thickness near nipple
        cooperThick = 0.15;
        leftBreast = true; % left breast or right breast
        outputDir = './mat/' % output dirctory
    end
     
    properties(Dependent)
        adipSamThick    % the thickness of area for sampling the radius of adipose shpere
    end
    
    methods
        function obj = base(targetGlaFrac,skinThick,nippleLen,nippleRad,...
                areolaRad,muscThick,leftBreast,outputDir)
            if nargin == 0
                disp("<base>: Use default parameters, set VGF(volume glandular fraction) as 50%");
            elseif nargin == 1
                obj.targetGlaFrac = targetGlaFrac;
                disp(['<base>: Use default parameters, set VGF(volume glandular fraction) as ',...
                    num2str(targetGlaFrac),'%']);
            elseif nargin == 2
                obj.targetGlaFrac = targetGlaFrac;
                obj.leftBreast = leftBreast;
            elseif nargin == 11
                obj.targetGlaFrac = targetGlaFrac;
                obj.skinThick = skinThick;
                obj.nippleLen = nippleLen;
                obj.nippleRad = nippleRad;
                obj.areolaRad = areolaRad;
                obj.muscThick = muscThick;
                obj.adipbThick = adipbThick;
                obj.adipnThick = adipnThick;
                obj.cooperThick = cooperThick;
                obj.leftBreast = leftBreast;
                obj.outputDir = outputDir;
            else
                disp("<base>: Incorrect number of arguments");
            end
        end
        
        function adipSamThick = get.adipSamThick(obj)
            adipSamThick = obj.adipnThick/2;
        end

        bool_skin = creSkin(obj,v,bool_surf,bool_nipple,nippleP);
        % create skin logical area
        [bool_fAdip,bool_bAdip,bool_fibGla] = creSubAdip(obj,v,bool_surf,nippleP,adipShRad);
        % create ventral(front) adipose logical area/ postero-lateral(back) adipose logical area

    end

    methods(Static)
        
    end
end

