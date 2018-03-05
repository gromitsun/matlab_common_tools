function mask = disk_mask(im, r, origin)

if nargin < 3
    origin = [0 0];
end

nx = size(im, 2);
ny = size(im, 1);

x = (-(nx-1)/2:(nx-1)/2) - origin(1);
y = (-(ny-1)/2:(ny-1)/2) - origin(2);

[xx, yy] = meshgrid(x, y);
mask = ((xx.^2 + yy.^2) <= r.^2);

end
