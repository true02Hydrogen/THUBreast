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
ind00 = floor(y)+1 + r*floor(x);      %左上
r00x  = uxmat(ind00);
r00y  = uymat(ind00); clear ind00
n00 = d00x.*r00x + d00y.*r00y; clear d00x r00x d00y r00y

d10x = x-floor(x)-1; d10y = y-floor(y);
ind10 = floor(y)+1 + r*(floor(x)+1);  %右上
r10x  = uxmat(ind10);
r10y  = uymat(ind10); clear ind10
n10 = d10x.*r10x + d10y.*r10y; clear d10x r10x d10y r10y

d01x = x-floor(x);   d01y = y-floor(y)-1;
ind01 = floor(y)+2 + r*floor(x);      %左下
r01x  = uxmat(ind01);
r01y  = uymat(ind01); clear ind01
n01 = d01x.*r01x + d01y.*r01y; clear d01x r01x d01y r01y

d11x = x-floor(x)-1; d11y = y-floor(y)-1;
ind11 = floor(y)+2 + r*(floor(x)+1);  %右下
r11x  = uxmat(ind11);
r11y  = uymat(ind11); clear ind11
n11 = d11x.*r11x + d11y.*r11y; clear d11x r11x d11y r11y

