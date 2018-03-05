function R = roty(ang)
% Generate rotation matrix for 3-dimensional rotation about y-axis (2nd dimension)
% x_new = x_old * R, where x_new and x_old are column vectors
% ang is given in radians.

R = [cos(ang) 0 sin(ang); 0 1 0; -sin(ang) 0 cos(ang)];

end