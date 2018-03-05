function out = ball3d(nx, ny, nz, r, nx0, ny0, nz0)

if nargin < 7
    nx0 = (nx+1)/2;
    ny0 = (ny+1)/2;
    nz0 = (nz+1)/2;
end

[xx, yy, zz] = meshgrid(1:nx,1:ny,1:nz);

out = (xx-nx0).^2 + (yy-ny0).^2 + (zz-nz0).^2 <= r^2;