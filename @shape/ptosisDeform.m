function outputP = ptosisDeform(doPtosis,inputP,b0,b1)
if doPtosis
    inputpx = inputP(:,1);
    inputpy = inputP(:,2);
    inputpz = inputP(:,3);
    outputpx = inputpx;
    outputpy = inputpy;
    outputpz = inputpz-(b0*inputpx+b1*inputpx.^2);
    outputP = cat(2,outputpx,outputpy,outputpz);
else
    outputP = inputP;
end

