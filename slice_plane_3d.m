function [xd, yd, zd] = slice_plane_3d(sz, vx, vy, vz, varargin)
% generate slice plane coordinates xd, yd, zd
% The slice plane is given by its normal vz and two in-plane vectors vx, vy
% and a point p (point) on the plane
% nx, ny, nz give the size of the 3D array to be sliced
% To visualize the slice, use 
%   slice(V, xd, yd, zd); shading interp;
% or
%   im = interp3(V, xd, yd, zd); imagesc(im);

%% parse inputs
ip = inputParser;
ip.addParameter('point', [], @isnumeric);
ip.addParameter('dim', 3, @isnumeric);
ip.addParameter('order', 'yxz', @isstr);

parse(ip, varargin{:});

p = ip.Results.point;
dim = ip.Results.dim;
ax_order = ip.Results.order;

%% Slicing on the dimensions other than the third
switch dim
    case 1
        [xd, yd, zd] = slice_plane_3d(sz, vy, vz, vx, 'dim', 3, ...
            'point', p, 'order', ax_order);
        return;
    case 2
        [xd, yd, zd] = slice_plane_3d(sz, vz, vx, vy, 'dim', 3, ...
            'point', p, 'order', ax_order);
        return;
end

%% Get sizes
switch ax_order
    case 'yxz'
        nx = sz(2);
        ny = sz(1);
        nz = sz(3);
    case 'xyz'
        nx = sz(1);
        ny = sz(2);
        nz = sz(3);
end

% initial center position of the slicing plane
p0 = [(nx+1)/2, (ny+1)/2, (nz+1)/2]; % center of volume

% point on slicing plane (default)
if isempty(p)
    p = p0;
end

% radius of slicing plane
r = ceil(sqrt(nx^2+ny^2+nz^2)/2);

%% normalize new axes vectors
vx = vx ./ norm(vx);
vy = vy ./ norm(vy);
vz = vz ./ norm(vz);

%% Slicing
% initialize slicing plane
switch ax_order
    case 'yxz'
        [xd, yd] = meshgrid(linspace(-r, r, 2*r+1), linspace(-r, r, 2*r+1));
    case 'xyz'
        [yd, xd] = meshgrid(linspace(-r, r, 2*r+1), linspace(-r, r, 2*r+1));
end
zd = zeros(2*r+1);

xdSz = size(xd);

% rotate coordinates back to original axes
subs = [xd(:), yd(:), zd(:)]*[vx(:), vy(:), vz(:)]';

% shift the plane
p = dot(p-p0, vz) * vz + p0; % effective shift

xd = reshape(subs(:,1) + p(1), xdSz);
yd = reshape(subs(:,2) + p(2), xdSz);
zd = reshape(subs(:,3) + p(3), xdSz);

%% Cropping
% crop the plane to valid region
dr = dim_range((xd >= 1) & (xd <= nx) & (yd >= 1) & (yd <= ny) & (zd >= 1) & (zd <= nz));
xd = xd(dr(1):dr(2), dr(3):dr(4));
yd = yd(dr(1):dr(2), dr(3):dr(4));
zd = zd(dr(1):dr(2), dr(3):dr(4));