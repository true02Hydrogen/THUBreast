function V = skinVolume(surfVert,surfFaces,skinThick)
avert = surfVert(surfFaces(:,1),:);
ax = avert(:,1);ay = avert(:,2);az = avert(:,3);
bvert = surfVert(surfFaces(:,2),:);
bx = bvert(:,1);by = bvert(:,2);bz = bvert(:,3);
cvert = surfVert(surfFaces(:,3),:);
cx = cvert(:,1);cy = cvert(:,2);cz = cvert(:,3);
s = 0.5*(ax.*by.*cz+bx.*cy.*az+cx.*ay.*bz-ax.*cy.*bz-bx.*ay.*cz-cx.*by.*az);
S = sum(s,"all");
V = S*skinThick/1000;
end

