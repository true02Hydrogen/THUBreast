function [uxmat,uymat] = randxymat(numx,numy) 
num = numx*numy;
uxmat = zeros(numy,numx);
uymat = zeros(numy,numx);

for j = 1:num
    k = 0;
    while k==0
        randxy = rand(1,2);
        if (randxy(1)-0.5)^2+(randxy(2)-0.5)^2<=0.25
            k = k+1;
            uxmat(j) = randxy(1);
            uymat(j) = randxy(2);
        end
    end
end

uxmat=(uxmat-0.5)*2;
uymat=(uymat-0.5)*2;

uxmat([end-1,end],:)=uxmat([1,2],:); uymat([end-1,end],:)=uymat([1,2],:);
uxmat(:,[end-1,end])=uxmat(:,[1,2]); uymat(:,[end-1,end])=uymat(:,[1,2]);

