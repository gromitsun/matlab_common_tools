function out = rotate_3d(v, n1, n2, n3, interpolation, order)
% Rotate 3D array v so that new axes align along vectors designated by
% n1, n2, n3 (dimension 1, 2, 3 of the array if order == '123')
% nx, ny, nz (dimension 2, 1, 3 of the array if order == 'xyz')
% See also project_3d

if nargin < 5
    interpolation = 'none';
end

if nargin < 6
    order = 'xyz';
end




switch interpolation
    case 'none'
        [xx, yy, zz] = meshgrid(1:size(v, 2), 1:size(v, 1), 1:size(v, 3));
        % select only non-zero and non-nan values
        valid = isfinite(v) & (v~=0);
        % rotate the coordinates
        if strcmp(order, 'xyz')
            coord_new = [xx(valid), yy(valid), zz(valid)] * [n1(:), n2(:), n3(:)];
            coord_new = round(coord_new(:,[2 1 3]));
        else
            coord_new = [yy(valid), xx(valid), zz(valid)] * [n1(:), n2(:), n3(:)];
            coord_new = round(coord_new);
        end
        % shift coordinates so that coordinates start from 1
        offset = min(coord_new, [], 1);
        for i=1:3
            coord_new(:,i) = coord_new(:,i) - offset(i) + 1;
        end

        out = accumarray(coord_new, v(valid));
    
    otherwise
        if strcmp(order, 'xyz')
            A = [[n1(:), n2(:), n3(:), zeros(3,1)]; [0, 0, 0, 1]];
        else
            p = [2 1 3];
            n1 = n1(:);
            n2 = n2(:);
            n3 = n3(:);
            A = [[n2(p), n1(p), n3(p), zeros(3,1)]; [0, 0, 0, 1]];
        end
        tform = affine3d(A);
        out = imwarp(v, tform, interpolation, 'FillValues', nan);
end

