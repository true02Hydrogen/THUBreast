rb = 48.58 ; rt = 99.317;
rl = 80.299; rr = 73.26 ;
rh = 58.484;

vol = 482; tar_vol = 447;
scale = tar_vol/vol;
scale = power(scale,1/3);
rb = rb*scale; rt = rt*scale;
rl = rl*scale; rr = rr*scale;
rh = rh*scale;

eps1 = 1.2;
eps2 = 1;

ptosisB0 = 0.07;  ptosisB1 = 0.00;
turnC0 = -0.02; turnC1 = 0.002; %c1 
topShapeS0 = -1.5;  topShapeT0 = 0.015; topShapeS1 = -0.4; topShapeT1 = -0.2;
flattenSideG0 = 0.8;  flattenSideG1 = 0.5;
turnTopH0 = 9.0;  turnTopH1 = 1.41;

% b0 = ptosisB0; b1 = ptosisB1;
% pz = 0-(b0*rh+b1*rh.^2);
% ratio = (rb+pz)/(rb+rt);
% disp(ratio);