function bool_mat = plyVoxelize(obj,FV,issolid)
if nargin == 2
    issolid = true;
end

v = obj;
[Nx,Ny,Nz] = v.dim();
VolumeSize = [Nx,Ny,Nz];
bool_mat = false(VolumeSize);

Vertices = FV.vertices;
Faces = FV.faces;

Vertices = (Vertices-[v.Xlower,v.Ylower,v.Zlower])*v.Res;

VerticesA = Vertices(Faces(:,1),:);
VerticesB = Vertices(Faces(:,2),:);
VerticesC = Vertices(Faces(:,3),:);

while(~isempty(VerticesA))
    % Only draw inside voxel
    checkA=~((VerticesA(:,1)<1)|(VerticesA(:,2)<1)|(VerticesA(:,3)<1)|(VerticesA(:,1)>VolumeSize(1))|(VerticesA(:,2)>VolumeSize(2))|(VerticesA(:,3)>VolumeSize(3)));
    checkB=~((VerticesB(:,1)<1)|(VerticesB(:,2)<1)|(VerticesB(:,3)<1)|(VerticesB(:,1)>VolumeSize(1))|(VerticesB(:,2)>VolumeSize(2))|(VerticesB(:,3)>VolumeSize(3)));
    checkC=~((VerticesC(:,1)<1)|(VerticesC(:,2)<1)|(VerticesC(:,3)<1)|(VerticesC(:,1)>VolumeSize(1))|(VerticesC(:,2)>VolumeSize(2))|(VerticesC(:,3)>VolumeSize(3)));

    VA =VerticesA(checkA,:);
    VB =VerticesB(checkB,:);
    VC =VerticesC(checkC,:);

    % Draw voxel
    bool_mat(sub2ind(VolumeSize,round(VA(:,1)),round(VA(:,2)), round(VA(:,3))))=true;
    bool_mat(sub2ind(VolumeSize,round(VB(:,1)),round(VB(:,2)), round(VB(:,3))))=true;
    bool_mat(sub2ind(VolumeSize,round(VC(:,1)),round(VC(:,2)), round(VC(:,3))))=true;
    
    VolumeSize = size(bool_mat);
    
    check1=(VerticesA(:,1)<1)&(VerticesB(:,1)<1)&(VerticesC(:,1)<1);
    check2=(VerticesA(:,2)<1)&(VerticesB(:,2)<1)&(VerticesC(:,2)<1);
    check3=(VerticesA(:,3)<1)&(VerticesB(:,3)<1)&(VerticesC(:,3)<1);
    check4=(VerticesA(:,1)>VolumeSize(1))&(VerticesB(:,1)>VolumeSize(1))&(VerticesC(:,1)>VolumeSize(1));
    check5=(VerticesA(:,2)>VolumeSize(2))&(VerticesB(:,2)>VolumeSize(2))&(VerticesC(:,2)>VolumeSize(2));
    check6=(VerticesA(:,3)>VolumeSize(3))&(VerticesB(:,3)>VolumeSize(3))&(VerticesC(:,3)>VolumeSize(3));

    outside = check1|check2|check3|check4|check5|check6;

    % Only keep inside faces
    VerticesA = VerticesA(~outside,:);
    VerticesB = VerticesB(~outside,:);
    VerticesC = VerticesC(~outside,:);
    
    VerticesAnew = zeros(0,3);
    VerticesBnew = zeros(0,3);
    VerticesCnew = zeros(0,3);
    
    if(~isempty(VerticesA))
        % Split face, if edge larger than 0.5 voxel
        dist1=(VerticesA(:,1)-VerticesB(:,1)).*(VerticesA(:,1)-VerticesB(:,1))+(VerticesA(:,2)-VerticesB(:,2)).*(VerticesA(:,2)-VerticesB(:,2))+(VerticesA(:,3)-VerticesB(:,3)).*(VerticesA(:,3)-VerticesB(:,3));
        dist2=(VerticesC(:,1)-VerticesB(:,1)).*(VerticesC(:,1)-VerticesB(:,1))+(VerticesC(:,2)-VerticesB(:,2)).*(VerticesC(:,2)-VerticesB(:,2))+(VerticesC(:,3)-VerticesB(:,3)).*(VerticesC(:,3)-VerticesB(:,3));
        dist3=(VerticesA(:,1)-VerticesC(:,1)).*(VerticesA(:,1)-VerticesC(:,1))+(VerticesA(:,2)-VerticesC(:,2)).*(VerticesA(:,2)-VerticesC(:,2))+(VerticesA(:,3)-VerticesC(:,3)).*(VerticesA(:,3)-VerticesC(:,3));
        
        [maxdist,maxindex] = max([dist1,dist2,dist3],[],2);
        
        split = maxdist > 0.5;
        m1 = maxindex == 1 & split;
        m2 = maxindex == 2 & split;
        m3 = maxindex == 3 & split;
        if(any(m1))
            VA = VerticesA(m1,:);
            VB = VerticesB(m1,:);
            VC = VerticesC(m1,:);
            VN=(VA+VB)/2;
            
            VerticesAnew = [VerticesAnew;VN;VA];
            VerticesBnew = [VerticesBnew;VB;VN];
            VerticesCnew = [VerticesCnew;VC;VC];
        end
        
        if(any(m2))
            VA = VerticesA(m2,:);
            VB = VerticesB(m2,:);
            VC = VerticesC(m2,:);
            VN=(VC+VB)/2;
            
            VerticesAnew = [VerticesAnew;VA;VA];
            VerticesBnew = [VerticesBnew;VN;VB];
            VerticesCnew = [VerticesCnew;VC;VN];
        end
        
        if(any(m3))
            VA = VerticesA(m3,:);
            VB = VerticesB(m3,:);
            VC = VerticesC(m3,:);
            VN=(VC+VA)/2;
            
            VerticesAnew = [VerticesAnew;VN;VA];
            VerticesBnew = [VerticesBnew;VB;VB];
            VerticesCnew = [VerticesCnew;VC;VN];
        end
    end
    VerticesA = VerticesAnew;
    VerticesB = VerticesBnew;
    VerticesC = VerticesCnew;
end

if issolid
    bool_mat = imfill(bool_mat,'holes');
end