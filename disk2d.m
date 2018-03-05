function out = disk2d(nx, ny, r, nx0, ny0)

if nargin < 5
    nx0 = (nx+1)/2;
    ny0 = (ny+1)/2;
end

[xx, yy] = meshgrid(1:nx,1:ny);

out = (xx-nx0).^2 + (yy-ny0).^2 <= r^2;