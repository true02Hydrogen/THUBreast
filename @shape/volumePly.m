function V = volumePly(surfVert,surfFaces)
avert = surfVert(surfFaces(:,1),:);
bvert = surfVert(surfFaces(:,2),:);
cvert = surfVert(surfFaces(:,3),:);
V = sum(abs(sum(avert.*(cross(bvert,cvert,2))/6,2)),1)/1000;
end

