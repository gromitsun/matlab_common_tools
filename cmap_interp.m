function cmap = cmap_interp(colors, nlevels)
% cmap_interp creates a colormap from interpolating rgb triplets
% provided in colors.

if nargin < 2
    nlevels = 64;
end

n0 = size(colors, 1);

if n0 < 2
    colors = [[1,1,1]; colors];
    n0 = n0 + 1;
end

cmap = interp1(1:n0, colors, linspace(1,n0,nlevels));

        