rb = 57.943; rt = 83.224;
rl = 72.003; rr = 61.508;
rh = 45.361;

vol = 333; tar_vol = 309;
scale = tar_vol/vol;
scale = power(scale,1/3);
rb = rb*scale; rt = rt*scale;
rl = rl*scale; rr = rr*scale;
rh = rh*scale;

eps1 = 1.2;
eps2 = 1;

ptosisB0 = 0.3;  ptosisB1 = 0.001;
turnC0 = -0.02; turnC1 = 0.002;
topShapeS0 = -1.5;  topShapeT0 = 0.010; topShapeS1 = -0.3; topShapeT1 = -0.2;
flattenSideG0 = 1.0;  flattenSideG1 = 1.0;
turnTopH0 = 9.166;  turnTopH1 = 1.375;

% b0 = ptosisB0; b1 = ptosisB1;
% pz = 0-(b0*rh+b1*rh.^2);
% ratio = (rb+pz)/(rb+rt);
% disp(ratio);