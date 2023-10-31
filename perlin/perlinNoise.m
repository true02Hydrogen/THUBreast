function z = perlinNoise(x,y,uxmat,uymat)
[n00,n10,n01,n11] = gridGradient(x,y,uxmat,uymat);
n0 = lerp(n00,n10,x-floor(x));
n1 = lerp(n01,n11,x-floor(x));
z  = lerp(n0, n1, y-floor(y));
% normalize;
if z*2 > 1 
    z = 1;
elseif z*2 < -1 
    z = -1;
else
    z = z*2;
end






