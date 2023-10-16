function outputP = topshapeDeform(doTopShape,inputP,inputA,s0,t0,s1,t1)
    if doTopShape
        inputpx = inputP(:,1);
        inputpy = inputP(:,2);
        inputpz = inputP(:,3);
        inputphi= inputA(:,2);
        u = inputphi/(pi/2);
        outputpx = inputpx;
        outputpy = inputpy;
        outputpz = zeros(size(inputpz));
        outputpz(inputpz>0) = ...
            inputpz(inputpz>0).*f1(u(inputpz>0),s0,t0,s1,t1);
        outputpz(inputpz<0) = inputpz(inputpz<0);
        outputP = cat(2,outputpx,outputpy,outputpz);
    else
        outputP = inputP;
    end
end

function fu = f1(u,s0,t0,s1,t1)
    A =-1/2*t0-3*s0-3*s1+1/2*t1;
    B = 3/2*t0+8*s0+7*s1-t1;
    C =-3/2*t0-6*s0-4*s1+1/2*t1;
    D = 1/2*t0;
    E = s0;
    F = 1;
    fu = A*u.^5+B*u.^4+C*u.^3+D*u.^2+E*u+F;
end
