function [proj12, proj13, proj23] = project_3d(v, n1, n2, n3)
% Sum 3D array v along axes designated by
% n1, n2, n3 (dimension 1, 2, 3 of the array).
% See also rotate_3d

[xx, yy, zz] = meshgrid(1:size(v, 2), 1:size(v, 1), 1:size(v, 3));

valid = isfinite(v) & (v~=0);

coord_new = [yy(valid), xx(valid), zz(valid)] * [n1(:), n2(:), n3(:)];

coord_new = round(coord_new);
offset = min(coord_new, [], 1);
for i=1:3
    coord_new(:,i) = coord_new(:,i) - offset(i) + 1;
end

proj12 = accumarray(coord_new(:,[1,2]), v(valid));
proj13 = accumarray(coord_new(:,[1,3]), v(valid));
proj23 = accumarray(coord_new(:,[2,3]), v(valid));


