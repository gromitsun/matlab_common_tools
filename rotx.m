function R = rotx(ang)
% Generate rotation matrix for 3-dimensional rotation about x-axis (1st dimension)
% x_new = x_old * R, where x_new and x_old are column vectors
% ang is given in radians.

R = [1 0 0; 0 cos(ang) -sin(ang); 0 sin(ang) cos(ang)];

end