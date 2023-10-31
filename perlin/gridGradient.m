function [n00,n10,n01,n11] = gridGradient(x,y,uxmat,uymat)
% gridGradient:According to the voxelized coordinate matrix, the weight value of each voxel point corresponding to the surrounding square points is calculated;
% Input:
%   x       The theta value of each voxel point of the voxelized cube, a three-dimensional matrix
%   y       The phi   value of each voxel point of the voxelized cube, a three-dimensional matrix
%   uxmat   The extracted fixed grid point gradient vector x value
%   uymat   The extracted fixed grid point gradient vector y value
% Output：
%   [n00,n10,n01,n11]: For each x,y value corresponds to the grid point weight
% written by Wangjiahao

[r,~] = size(uxmat);

x(x<0) = 0; y(y<0) = 0; %Prevents accuracy problems of PI,1e-7

d00x = x-floor(x);   d00y = y-floor(y);
d10x = x-floor(x)-1; d10y = y-floor(y);
d01x = x-floor(x);   d01y = y-floor(y)-1;
d11x = x-floor(x)-1; d11y = y-floor(y)-1;

ind00 = floor(y)+1 + r*floor(x);      %left upper
ind10 = floor(y)+1 + r*(floor(x)+1);  %right upper
ind01 = floor(y)+2 + r*floor(x);      %left down
ind11 = floor(y)+2 + r*(floor(x)+1);  %right down

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

