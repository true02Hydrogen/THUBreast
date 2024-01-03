function bool_mat = muscleVoxelize(obj,slice,muscThick)
v = obj;

[~,Ny,Nz] = v.dim();
Nx = ceil(muscThick*v.Res);

bool_mat = zeros(Nx,Ny,Nz,'logical');

for i = 1:Nx
    bool_mat(i,:,:) = slice;
end

end