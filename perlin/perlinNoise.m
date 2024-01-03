function z = perlinNoise(x,y,uxmat,uymat)
%给定点[x y]; 在网格及对应的uxmat uymat梯度向量下的噪声取值

[n00,n10,n01,n11] = gridGradient(x,y,uxmat,uymat);
clear uxmat uymat;

%然后再加权
n0 = lerp(n00,n10,x-floor(x)); clear n00 n10
n1 = lerp(n01,n11,x-floor(x)); clear n01 n11
z  = lerp(n0, n1, y-floor(y));%把最终数据n存储到相应的矩阵中
clear n0 n1 x y

%把最终数值规划到-1，1之间
if z*2 > 1 
    z = 1;
elseif z*2 < -1 
    z = -1;
else
    z = z*2;
end






