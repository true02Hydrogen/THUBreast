function breast = minbreast(breast)
bool_breast = breast ~= 1;
pvnSurf2 = zeros(1,size(bool_breast,1)); %plane voxel number(xz plane)
for i = 1:size(bool_breast,1)
    pvnSurf2(i) = size(find(bool_breast(i,:,:)),1);
end
pvnSurf2p = find(pvnSurf2 ~= 0); %plane voxel number / max position
breast = breast(pvnSurf2p(1):end,:,:);