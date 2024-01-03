rb = 75.091; rt = 92.316;
rl = 84.167; rr = 74.259;
rh = 71.059;

vol = 730; tar_vol = 858;
scale = tar_vol/vol;
scale = power(scale,1/3);
rb = rb*scale; rt = rt*scale;
rl = rl*scale; rr = rr*scale;
rh = rh*scale;

eps1 = 1.2;
eps2 = 1;

ptosisB0 = 0.3;  ptosisB1 = 0.00065;
turnC0 = -0.03; turnC1 = 0.001;
topShapeS0 = -1.5;  topShapeT0 = 0.015; topShapeS1 = -0.38; topShapeT1 = -0.2;
flattenSideG0 = 0.9;  flattenSideG1 = 0.5;
turnTopH0 = 9.5;  turnTopH1 = 1.46;

% b0 = ptosisB0; b1 = ptosisB1;
% pz = 0-(b0*rh+b1*rh.^2);
% ratio = (rb+pz)/(rb+rt);
% disp(ratio);