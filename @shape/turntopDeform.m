function outputP = turntopDeform(doTurnTop,inputP,h0,h1,leftBreast)
if doTurnTop
    inputpx = inputP(:,1);
    inputpy = inputP(:,2);
    inputpz = inputP(:,3);
    u = inputpz/max(abs(max(inputpz)),abs(min(inputpz)));
    outputpx = inputpx;
    outputpy = zeros(size(inputpy));
    if leftBreast
        outputpy(inputpz>0) = inputpy(inputpz>0)+f3(u(u>0),h0,h1);
    else
        outputpy(inputpz>0) = inputpy(inputpz>0)-f3(u(u>0),h0,h1);
    end
    outputpy(inputpz<0) = inputpy(inputpz<0);
    outputpz = inputpz;
    outputP = cat(2,outputpx,outputpy,outputpz);
else
    outputP = inputP;
end
end

function fu = f3(u,h0,h1)
fu = h0*u+h1*u.^2;
end
