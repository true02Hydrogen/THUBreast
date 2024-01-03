function area = plySkinArea(FV)

verts = FV.vertices;
faces = FV.faces;
nums = size(faces,1);
areas = zeros(nums,1); % |(a × b)|/6

for i = 1:nums
    face = faces(i,:);
    if ~isempty(find(face==1, 1))
        areas(i) = 0;
        continue;
    end

    a = verts(face(2),:)-verts(face(1),:);
    b = verts(face(3),:)-verts(face(1),:);
    areas(i) = norm(cross(a,b))/2;
end
area = sum(areas)/1000;
end
