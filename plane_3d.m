function out = plane_3d(p, nvec, nx, ny, nz)

[xx, yy, zz] = meshgrid(1:nx,1:ny,1:nz);

xx = xx - p(1);
yy = yy - p(2);
zz = zz - p(3);

out = reshape(round(cat(2,xx(:),yy(:),zz(:))*nvec(:)) == 0, ny, nx, nz);