function [slice, sliceInd, subX, subY, subZ] = extractSlice4(volume,pt,nx,ny,nz,varargin)

%%extractSlice extracts an arbitray slice from a volume.
% [slice, sliceInd, subX, subY, subZ] = extractSlice extracts an arbitrary 
% slice given the center and normal of the slice.  The function outputs the 
% intensities, indices and the subscripts of the slice base on the input volume.
% If you are familiar with IDL, this is the equivalent function to EXTRACT_SLICE.
%
% Note that output array 'sliceInd' contains integers and NaNs if the particular
% locations are outside the volume, while output arrays 'subX, subY, subZ' 
% contain floating points and does not contain NaNs when locations are
% outside the volume.
%
% Example:
% %Extracts slices from a mri volume by varying the slice orientation from
% sagittal to transverse while shifting the center of the slice from left to right.
% %(pardon me for demonstrating with an image without orientation labels and out-of-scale pixels.)
%
% load mri;
% D = squeeze(D);
% for i = 0:30;
% pt = [64 i*2 14];
% vec = [0 30-i i];
% [slice, sliceInd,subX,subY,subZ] = extractSlice(D,pt(1),pt(2),pt(3),vec(1),vec(2),vec(3),64);
% surf(subX,subY,subZ,slice,'FaceColor','texturemap','EdgeColor','none');
% axis([1 130 1 130 1 40]);
% drawnow;end;
%
%
% $Revision: 1.0 $ $Date: 2011/07/02 18:00$ $Author: Pangyu Teng $
% $Updated $ $Date: 2011/08/012 07:00$ $Author: Pangyu Teng $


p = inputParser;
p.addParameter('dim', 3, @isnumeric);
p.addParameter('radius', 50, @isnumeric);
p.addParameter('calc_ind', false, @(x) (isnumeric(x) | islogical(x)));
p.addParameter('order', 'yxz', @isstr);

parse(p, varargin{:});

dim = p.Results.dim;
radius = p.Results.radius;
calc_ind = p.Results.calc_ind;
ax_order = p.Results.order;

if dim == 1
    [slice, sliceInd, subX, subY, subZ] = ...
        extractSlice4(volume, pt, ny, nz, nx, 'dim', 3, ...
        'radius', radius, 'order', ax_order, 'calc_ind', calc_ind);
    return;
elseif dim == 2
    [slice, sliceInd, subX, subY, subZ] = ...
        extractSlice4(volume, pt, nz, nx, ny, 'dim', 3, ...
        'radius', radius, 'order', ax_order, 'calc_ind', calc_ind);
    return;
end

%initialize needed parameters
%size of volume.
volSz=size(volume); 

%assume the slice is initially at [0,0,0] with a vector [0,0,1] and a silceSize.
switch ax_order
    case 'yxz'
        [xd, yd] = meshgrid(linspace(-radius,radius,2*radius+1),linspace(-radius,radius,2*radius+1));
    case 'xyz'
        [yd, xd] = meshgrid(linspace(-radius,radius,2*radius+1),linspace(-radius,radius,2*radius+1));
end
zd = zeros(2*radius+1);


%get the coordinates
xdSz=size(xd);

subs = [xd(:) yd(:) zd(:)] * [nx(:) ny(:) nz(:)]';

%translate;
subX = reshape(subs(:,1) + pt(1), xdSz);
subY = reshape(subs(:,2) + pt(2), xdSz);
subZ = reshape(subs(:,3) + pt(3), xdSz);

%round the subscripts to obtain its corresponding values and indices in the volume.
xd = round(subX);
yd = round(subY);
zd = round(subZ);


%obtain the requested slice intensitis and indices from the input volume.
sliceInd=nan(xdSz);
slice=nan(xdSz);
switch ax_order
    case 'yxz'
        for i = 1:xdSz(1)
            for j = 1:xdSz(2)
        %         if xd(i,j) > 0 && xd(i,j)<= volSz(1) &&... % bug
        %              yd(i,j) > 0 && yd(i,j)<= volSz(2) &&... % bug
                if xd(i,j) > 0 && xd(i,j)<= volSz(2) &&...
                    yd(i,j) > 0 && yd(i,j)<= volSz(1) &&...
                    zd(i,j) > 0 && zd(i,j)<= volSz(3),
        %              sliceInd(i,j) = sub2ind(volSz,xd(i,j),yd(i,j),zd(i,j)); % bug
        %              slice(i,j) = volume(xd(i,j),yd(i,j),zd(i,j)); % bug
                    if calc_ind
                        sliceInd(i,j) = sub2ind(volSz,yd(i,j),xd(i,j),zd(i,j));
                    end
                    slice(i,j) = volume(yd(i,j),xd(i,j),zd(i,j));
                end
            end    
        end
    case 'xyz'
        for i = 1:xdSz(1)
            for j = 1:xdSz(2)
        %         if xd(i,j) > 0 && xd(i,j)<= volSz(1) &&... % bug
        %              yd(i,j) > 0 && yd(i,j)<= volSz(2) &&... % bug
                if xd(i,j) > 0 && xd(i,j)<= volSz(1) &&...
                    yd(i,j) > 0 && yd(i,j)<= volSz(2) &&...
                    zd(i,j) > 0 && zd(i,j)<= volSz(3),
        %              sliceInd(i,j) = sub2ind(volSz,xd(i,j),yd(i,j),zd(i,j)); % bug
        %              slice(i,j) = volume(xd(i,j),yd(i,j),zd(i,j)); % bug
                    if calc_ind
                        sliceInd(i,j) = sub2ind(volSz,xd(i,j),yd(i,j),zd(i,j));
                    end
                    slice(i,j) = volume(xd(i,j),yd(i,j),zd(i,j));
                end
            end    
        end
end