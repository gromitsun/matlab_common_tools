function [x_new, y_new, z_new] = rotate_coords(x, y, z, vx, vy, vz)
% Rotate coordinates x, y, z and output new coordinates with respect to new
% axes vx, vy, vz.
% The new axes vx, vy, vz are given in forms of vectors in the space
% defined by the old axes ux = [1 0 0], uy = [0 1 0], uz = [0 0 1]
% New coordinates are given by
% [x_new(:) y_new(:) z_new(:)] = [x(:) y(:) z(:)] * [vx(:) vy(:) vz(:)]';

out = [x(:), y(:), z(:)] * [vx(:), vy(:), vz(:)];

x_new(:) = out(:, 1);
y_new(:) = out(:, 2);
z_new(:) = out(:, 3);