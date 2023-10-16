classdef tissue
    
    properties(SetAccess=private,GetAccess=public)
        air    = 1;         %air
        nipple = 9;         %nipple
        fAdip  = 2;         %subcutaneous adipose(front)
        fgAdip = 3;         %adipose ellipsoid in fiberglandular area
        bAdip  = 4;         %postero-lateral adipose(back)
        cooper = 5;         %Cooper ligament
        fgFiber= 6;         %glandular in fiberglandular area
        ampul  = 7;         %ampulla lactifera
        skin   = 9;         %skin
        dTree  = 51;        %duct tree
        lob    = 71;        %TDLU,lobule
        gland  = 99;

        adipose= 100;
        fibroglandular  = 101; %contain Cooper ligament and glandular

        vein   = 10;        %vein
        artery = 11;        %artery
        muscle = 12;        %muscle

        G4air  = 1;
        G4subAdip = 2;
        G4innerAdip = 3;
        G4fiber = 5;
        G4skin  = 9;
        G4gland = 10;

        Sim_air = 1;
        Sim_skin = 2;
        Sim_adip = 3;
        Sim_gland = 10;    
    end
    
    methods
        function obj = tissue()
        end

        glandularity = glandularity(obj,breast);
        [vbd,maxvbd] = VBD(obj,breast);
        breast = toG4Voxel(obj,breast);
        breast = toG4SimVoxel(obj,breast);
    end

    methods(Static)
        Vfat = targetVfat(v,breast,targetGlaFrac);
        Vfat = targetVfat_vbd(v,breast,targetVBD);
    end
    
end

