function points2d = project2d(points, nvec)

% Calculate rotation matrices from nvec to [0 0 1]
rotm = vrrotvec2mat(vrrotvec(nvec, [0 0 1]));

% Rotate coordinates
points2d = points * rotm';

% Project to xy plane
points2d = points2d(:,1:2);

end