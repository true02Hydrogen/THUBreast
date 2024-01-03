function bool_mat = virtualAdipVoxelize(obj,slice,virtualAdipThick)
v = obj;

[~,Ny,Nz] = v.dim();
Nx = ceil(virtualAdipThick*v.Res);

bool_mat = zeros(Nx,Ny,Nz,'logical');

for i = 1:Nx
    bool_mat(i,:,:) = slice;
end

end