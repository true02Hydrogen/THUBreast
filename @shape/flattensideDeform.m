function outputP = flattensideDeform(doFlattenSide,inputP,g0,g1,leftBreast)
    if doFlattenSide
        inputpx = inputP(:,1);
        inputpy = inputP(:,2);
        inputpz = inputP(:,3);
        outputpx = inputpx;
        outputpy = zeros(size(inputpy));
        outputpz = inputpz;
        if leftBreast
            u = inputpy/abs(max(inputpy));
            outputpy(inputpy>0) = ...
                inputpy(inputpy>0).*f2(abs(u(inputpy>0)),g0,g1);
            outputpy(inputpy<0) = inputpy(inputpy<0);
        else
            u = inputpy/abs(min(inputpy));
            outputpy(inputpy<0) = ...
                inputpy(inputpy<0).*f2(abs(u(inputpy<0)),g0,g1);
            outputpy(inputpy>0) = inputpy(inputpy>0);
        end
        outputP = cat(2,outputpx,outputpy,outputpz);
    else
        outputP = inputP;
    end
end

function fu = f2(u,g0,g1)
    A = g1+2-2*g0;
    B = -g1-3+3*g0;
    C = 0;
    D = 1;
    fu = A*u.^3+B*u.^2+C*u+D;
end


