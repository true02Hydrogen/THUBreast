classdef voxelize < handle
    
    properties
        Res=5;
        Xupper=60.5;  Xlower=-60.5;
        Yupper=66.5;  Ylower=-45.5;
        Zupper=40.5;  Zlower=-0.5;
    end
    
    properties(Dependent)
        Nx; Ny; Nz;
    end
    
    methods
        function obj = voxelize(res,Xupper,Xlower,Yupper,Ylower,Zupper,Zlower)
            if nargin == 0
                disp("<voxelize>: Use default parameters");
            elseif nargin == 1
                obj.Res = res;
            elseif nargin == 7
                obj.Res = res;
                obj.Xupper = Xupper;
                obj.Xlower = Xlower;
                obj.Yupper = Yupper;
                obj.Ylower = Ylower;
                obj.Zupper = Zupper;
                obj.Zlower = Zlower;
            else
                disp("<voxelize>: Incorrect number of arguments");
            end
        end

        function  [Nx,Ny,Nz] = dim(obj)
            Nx=floor((obj.Xupper-obj.Xlower)*obj.Res);
            Ny=floor((obj.Yupper-obj.Ylower)*obj.Res);
            Nz=floor((obj.Zupper-obj.Zlower)*obj.Res);
            % d = [Nx,Ny,Nz];
        end

        function  X = x2X(obj,x)
            X=x/obj.Res+obj.Xlower; % X is the position coordinate, x is the voxel coordinate
        end

        function  x = X2x(obj,X)
            x=ceil((X-obj.Xlower)*obj.Res);
        end

        function  Y = y2Y(obj,y)
            Y=y/obj.Res+obj.Ylower;
        end

        function  y = Y2y(obj,Y)
            y=ceil((Y-obj.Ylower)*obj.Res);
        end

        function  Z = z2Z(obj,z)
            Z=z/obj.Res+obj.Zlower;
        end

        function  z = Z2z(obj,Z)
            z=ceil((Z-obj.Zlower)*obj.Res);
        end
        
        function  [X,Y,Z] = xyz2XYZ(obj,x,y,z)
            X=x/obj.Res+obj.Xlower;
            Y=y/obj.Res+obj.Ylower;
            Z=z/obj.Res+obj.Zlower;
        end

        function  [x,y,z] = XYZ2xyz(obj,X,Y,Z)
            x=ceil((X-obj.Xlower)*obj.Res);
            y=ceil((Y-obj.Ylower)*obj.Res);
            z=ceil((Z-obj.Zlower)*obj.Res);
        end


        [xBoxLow,xBoxUp,yBoxLow,yBoxUp,zBoxLow,zBoxUp] = Box(obj,P,R);
        bool_mat = cooperVoxelize(obj,bool_adip,direc);
        [bool_mat,box] = cylinderVoxelize(obj,P1,P2,R);
        bool_mat = adipShVoxelize(obj,bool_adip,nAdip,R);
        bool_mat = plyVoxelize(obj,FV,issolid);
        bool_mat = nippleVoxelize(obj,nippleP,nippleRad,nippleLen);
        [bool_mat,box] = shpereVoxelize(obj,P,R);
        [breast,actualGlaFrac] = adipElVoxelize(obj,targetGlaFrac,breast,nippleP,gcy,gcz);
%         bool_cooper = CooperVoxelize2(obj,bool_surf,nippleP,cooperThick);
    end

%     methods(Static)
%         [surfVert,surfFace] = CooperVoxelize2(nippleP);
%     end
end

