function R = rotz(ang)
% Generate rotation matrix for 3-dimensional rotation about z-axis (3rd dimension)
% x_new = x_old * R, where x_new and x_old are column vectors
% ang is given in radians.

R = [cos(ang) -sin(ang) 0; sin(ang) cos(ang) 0; 0 0 1];

end