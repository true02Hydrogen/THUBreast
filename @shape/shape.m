classdef shape
    
    properties
        shapeGridNum = 50 ;
        rt,rb,rl,rr,rh,eps1,eps2,

        doPtosis = true,%！！！
        ptosisB0,ptosisB1,

        doTurn = true,
        turnC0,turnC1,

        doTopShape = true,
        topShapeS0,topShapeS1,topShapeT0,topShapeT1,

        doFlattenSide = true,
        flattenSideG0,flattenSideG1,

        doTurnTop = true,
        turnTopH0,turnTopH1,

        doArmpit = true;
        dirc, sigma,

        doCoronalElongate = false;
        corElongK0 = 0.15,corElongK1 = 0.01,corElongK2 = 1,
    end
    
    methods
        function obj = shape(rt,rb,rl,rr,rh,eps1,eps2,...
                ptosisB0,ptosisB1,turnC0,turnC1,...
                topShapeS0,topShapeS1,topShapeT0,topShapeT1,...
                flattenSideG0,flattenSideG1,turnTopH0,turnTopH1,...
                corElongK0,corElongK1,corElongK2,...
                dirc,sigma)

            if nargin == 7
                obj.rt = rt;
                obj.rb = rb;
                obj.rl = rl;
                obj.rr = rr;
                obj.rh = rh;
                obj.eps1  = eps1;
                obj.eps2  = eps2;
            elseif nargin == 19
                obj.rt = rt;
                obj.rb = rb;
                obj.rl = rl;
                obj.rr = rr;
                obj.rh = rh;
                obj.eps1  = eps1;
                obj.eps2  = eps2;
                obj.ptosisB0 = ptosisB0;
                obj.ptosisB1 = ptosisB1;
                obj.turnC0 = turnC0;
                obj.turnC1 = turnC1;
                obj.topShapeS0 = topShapeS0;
                obj.topShapeS1 = topShapeS1;
                obj.topShapeT0 = topShapeT0;
                obj.topShapeT1 = topShapeT1;
                obj.flattenSideG0 = flattenSideG0;
                obj.flattenSideG1 = flattenSideG1;
                obj.turnTopH0 = turnTopH0;
                obj.turnTopH1 = turnTopH1;
            elseif nargin == 22
                obj.rt = rt;
                obj.rb = rb;
                obj.rl = rl;
                obj.rr = rr;
                obj.rh = rh;
                obj.eps1  = eps1;
                obj.eps2  = eps2;
                obj.ptosisB0 = ptosisB0;
                obj.ptosisB1 = ptosisB1;
                obj.turnC0 = turnC0;
                obj.turnC1 = turnC1;
                obj.topShapeS0 = topShapeS0;
                obj.topShapeS1 = topShapeS1;
                obj.topShapeT0 = topShapeT0;
                obj.topShapeT1 = topShapeT1;
                obj.flattenSideG0 = flattenSideG0;
                obj.flattenSideG1 = flattenSideG1;
                obj.turnTopH0 = turnTopH0;
                obj.turnTopH1 = turnTopH1;
                obj.corElongK0 = corElongK0;
                obj.corElongK1 = corElongK1;
                obj.corElongK2 = corElongK2;
            elseif nargin == 24
                obj.rt = rt;
                obj.rb = rb;
                obj.rl = rl;
                obj.rr = rr;
                obj.rh = rh;
                obj.eps1  = eps1;
                obj.eps2  = eps2;
                obj.ptosisB0 = ptosisB0;
                obj.ptosisB1 = ptosisB1;
                obj.turnC0 = turnC0;
                obj.turnC1 = turnC1;
                obj.topShapeS0 = topShapeS0;
                obj.topShapeS1 = topShapeS1;
                obj.topShapeT0 = topShapeT0;
                obj.topShapeT1 = topShapeT1;
                obj.flattenSideG0 = flattenSideG0;
                obj.flattenSideG1 = flattenSideG1;
                obj.turnTopH0 = turnTopH0;
                obj.turnTopH1 = turnTopH1;
                obj.corElongK0 = corElongK0;
                obj.corElongK1 = corElongK1;
                obj.corElongK2 = corElongK2;
                obj.dirc = dirc;
                obj.sigma = sigma;
            else
                disp("<shape>: Incorrect number of arguments");
            end
        end

        [surfVert,surfFaces] = shapePly(obj,leftBreast);
        [surfVert,surfFaces] = shapeFgPly(obj,leftBreast,nippleP,adipnThick);
    end

    methods(Static)
        %volume cm^3
        V = volumePly(surfVert,surfFaces);
        V = skinVolume(surfVert,surfFaces,skinThick);

        %deformation
        outputP = topshapeDeform(doTopShape,doPtosis,inputP,inputA,s0,t0,s1,t1);
        outputP = flattensideDeform(doFlattenSide,inputP,g0,g1,leftBreast);
        outputP = turntopDeform(doTurnTop,inputP,h0,h1,leftBreast);
        outputP = ptosisDeform(doPtosis,inputP,b0,b1);
        outputP = turnDeform(doTurn,inputP,c0,c1);
        outputP = coronalElongateDeform(doCoronalElongate,inputP,k0,k1,k2);
        %for armpit deformation
        outputP = addArmpitDeform(inputP);
        outputP = addArmpit(doArmpit,inputP,dirc,sigma);
    end
end
