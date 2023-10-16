function outputP = turnDeform(doTurn,inputP,c0,c1)
if doTurn
    inputpx = inputP(:,1);
    inputpy = inputP(:,2);
    inputpz = inputP(:,3);
    outputpx = inputpx;
    outputpy = inputpy + (c0*inputpx+c1*inputpx.^2);
    outputpz = inputpz;
    outputP = cat(2,outputpx,outputpy,outputpz);
else
    outputP = inputP;
end


