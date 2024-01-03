function vol = plyVolume(FV)

verts = FV.vertices;
faces = FV.faces;
nums = size(faces,1);
vols = zeros(nums,1); % |(a × b)· c|/6

for i = 1:nums
    face = faces(i,:);
    if ~isempty(find(face==1, 1))
        vols(i) = 0;
        continue;
    end

    a = verts(face(1),:);
    b = verts(face(2),:);
    c = verts(face(3),:);
    vols(i) = abs(dot(cross(a,b),c))/6;
end
vol = sum(vols)/1000;
end

