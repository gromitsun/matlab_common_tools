function [ave, r_edges, r, stddev] = radial_ave3(a, nbins, x, y, z)
% Calculate the radial average of volumetric data a
% Inputs
% a - 3D array
% nbins - number of bins in r. If nbins is a vector of length > 1, this
%         input is taken as the bin edges.
% x, y, z - coordinates as given by meshgrid. If x, y, z are not given, the
%           center of a will be taken as (0, 0, 0).
% Returns
% ave - radial averages at designated bins.
% r_edges - edges of the radial bins.
% r - 3D array consisting of the radial distances of the original 3D array
% stddev - radial standard deviations at designated bins.

if nargin < 5
    sz = size(a);
    x = (1:sz(2)) - (sz(2)+1)/2;
    y = (1:sz(1)) - (sz(1)+1)/2;
    z = (1:sz(3)) - (sz(3)+1)/2;
end

[xx, yy, zz] = meshgrid(x, y, z);

[~, ~, r] = cart2sph(xx, yy, zz);

if length(nbins) > 1 % radial_ave3(a, nbins, <x, y, z>)
    r_edges = nbins;
    nbins = length(nbins) - 1;
else  % radial_ave3(a, edges, <x, y, z>)
    r_edges = linspace(min(r(:)),max(r(:)),nbins+1);
end

ave = zeros(1, nbins);
if nargout > 3 % compute standard deviation
    stddev = zeros(1, nbins);
end

for i=1:nbins
    seg = (r>=r_edges(i)) & (r<r_edges(i+1));
    ave(i) = mean(a(seg));
    if nargout > 3 % compute standard deviation
       stddev(i) = std(a(seg));
    end
end