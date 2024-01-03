
rb = 52.581; rt = 57.015;
rl = 66.346; rr = 59.744;
rh = 36.772;

vol = 194; tar_vol = 212;
scale = tar_vol/vol;
scale = power(scale,1/3);
rb = rb*scale; rt = rt*scale;
rl = rl*scale; rr = rr*scale;
rh = rh*scale;

eps1 = 1.2;
eps2 = 1;

ptosisB0 = 0.2;  ptosisB1 = 0.0088;
turnC0 = -0.018; turnC1 = 0.002;
topShapeS0 = -1.3;  topShapeT0 = 0.010; topShapeS1 = -0.5; topShapeT1 = -0.1;
flattenSideG0 = 0.85;  flattenSideG1 = 0.9;
turnTopH0 = 9.0;  turnTopH1 = 1.39;

% b0 = ptosisB0; b1 = ptosisB1;
% pz = 0-(b0*rh+b1*rh.^2);
% ratio = (rb+pz)/(rb+rt);
% disp(ratio);