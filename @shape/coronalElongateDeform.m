function outputP = coronalElongateDeform(doCoronalElongate,inputP,k0,k1,k2)
if doCoronalElongate
    inputpx = inputP(:,1);
    inputpy = inputP(:,2);
    inputpz = inputP(:,3);

    maxx = abs(max(inputpx));
    norm_inputpx = inputpx/maxx;
    outputpx = ((1+k0)*norm_inputpx + k1*norm_inputpx.^2)*maxx;
    outputpy = k2*inputpy;
    outputpz = inputpz;
    outputP = cat(2,outputpx,outputpy,outputpz);
else
    outputP = inputP;
end

