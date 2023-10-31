function [n00,n10,n01,n11] = gridGradient(x,y,uxmat,uymat)
% gridGradient:根据体素化坐标矩阵算出每个体素点对应周围方格点权重值;
% Input:
%   x       体素化立方体每个体素点的theta值，三维矩阵
%   y       体素化立方体每个体素点的phi  值，三维矩阵
%   uxmat   抽取的固定网格点梯度向量x值
%   uymat   抽取的固定网格点梯度向量y值
% Output：
%   [n00,n10,n01,n11]: 对于每个x,y值对应的网格点权重
% written by Wangjiahao

[r,~] = size(uxmat);

x(x<0) = 0; y(y<0) = 0; %由于pi得精度输入得x y有可能略小于0，如1e-7

d00x = x-floor(x);   d00y = y-floor(y);
d10x = x-floor(x)-1; d10y = y-floor(y);
d01x = x-floor(x);   d01y = y-floor(y)-1;
d11x = x-floor(x)-1; d11y = y-floor(y)-1;

ind00 = floor(y)+1 + r*floor(x);      %左上
ind10 = floor(y)+1 + r*(floor(x)+1);  %右上
ind01 = floor(y)+2 + r*floor(x);      %左下
ind11 = floor(y)+2 + r*(floor(x)+1);  %右下

r00x  = uxmat(ind00);
r00y  = uymat(ind00);
r10x  = uxmat(ind10);
r10y  = uymat(ind10);
r01x  = uxmat(ind01);
r01y  = uymat(ind01);
r11x  = uxmat(ind11);
r11y  = uymat(ind11);

% fr_x = floor(x); fr_y = floor(y);
% for i =1:r
%     for j = 1:c
%         for k = 1:n
%             r00x(i,j,k)  = uxmat(fr_y(i,j,k)+1,fr_x(i,j,k)+1);
%             r00y(i,j,k)  = uymat(fr_y(i,j,k)+1,fr_x(i,j,k)+1);
%             r10x(i,j,k)  = uxmat(fr_y(i,j,k)+1,fr_x(i,j,k)+2);
%             r10y(i,j,k)  = uymat(fr_y(i,j,k)+1,fr_x(i,j,k)+2);
%             %注意边缘点数据关联问题，这就是前面多了一行一列的原因
%             r01x(i,j,k)  = uxmat(fr_y(i,j,k)+2,fr_x(i,j,k)+1);
%             r01y(i,j,k)  = uymat(fr_y(i,j,k)+2,fr_x(i,j,k)+1);
%             r11x(i,j,k)  = uxmat(fr_y(i,j,k)+2,fr_x(i,j,k)+2);
%             r11y(i,j,k)  = uymat(fr_y(i,j,k)+2,fr_x(i,j,k)+2);
%         end
%     end
% end

n00 = d00x.*r00x + d00y.*r00y;
n10 = d10x.*r10x + d10y.*r10y;
n01 = d01x.*r01x + d01y.*r01y;
n11 = d11x.*r11x + d11y.*r11y;

