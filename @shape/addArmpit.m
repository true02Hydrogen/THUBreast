function outputP = addArmpit(doArmpit,inputP,dirc,sigma)

if doArmpit
    armpitDir = dirc;
    X = inputP(2:end,1);
    Y = inputP(2:end,2);
    Z = inputP(2:end,3);
    [~,~,r] = cart2sph(X,Y,Z);
    
    thetaArmpit = acos((armpitDir(2)*Y+armpitDir(3)*Z)./(r*vecnorm(armpitDir)));
    rf = 1+0.5*exp(-1/2*thetaArmpit.^2/sigma^2);
    
    outputP = zeros(size(inputP));
    outputP(2:end,1) = X.*rf;
    outputP(2:end,2) = Y.*rf;
    outputP(2:end,3) = Z.*rf;
else
    outputP = inputP;
end

